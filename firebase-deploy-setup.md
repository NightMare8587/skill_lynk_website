# Firebase Hosting Deploy — One-Time Setup

`.github/workflows/deploy-web.yml` builds the static marketing site (and the
relocated Flutter app under `/app/`) and deploys to a **new, dedicated**
Firebase Hosting site — `skilllynk-www` — on every push to `main`. Same
Workload Identity Federation (OIDC) approach already proven in
`SkillLynk-Mobile`'s `deploy-web.yml`: no service account JSON key is ever
generated, stored, or rotated.

**Deliberately a *new* Hosting site, not `skill-lynk` (the mobile web PWA's
existing site)** — the two are different products (marketing/SEO vs. the
app's own web build) and were about to collide on the same domain by
accident. Also deliberately a **new, separate** Workload Identity pool/
provider rather than editing the mobile repo's existing one — narrower
blast radius, and it means this setup can be run without touching a
pipeline that already works.

**Run this once, in order.** Needs `gcloud` CLI + Firebase CLI authenticated
as someone with IAM Admin (or Owner) on `skill-lynk-app`, and Firebase
project-level access to create a new Hosting site.

## 1. Create the new Hosting site

```bash
export PROJECT_ID="skill-lynk-app"
export SITE_ID="skilllynk-www"   # -> https://skilllynk-www.web.app

firebase hosting:sites:create "$SITE_ID" --project "$PROJECT_ID"
```

If you'd rather use a different site ID (or already have a custom domain in
mind), swap `SITE_ID` here — but then also update `.firebaserc`'s
`targets.skill-lynk-app.hosting.skilllynk-www` array in this repo (the
*target name* `skilllynk-www` and the *site id* don't have to match, they
just do here for simplicity) and every `skilllynk-www.web.app` reference in
`public/*.html`, `public/sitemap.xml`, `public/robots.txt`.

## 2. Prerequisites

```bash
export REPO="NightMare8587/skill_lynk_website"   # exact owner/repo, case-sensitive
export POOL_ID="skilllynk-website-pool"
export PROVIDER_ID="github-actions-provider"
export SA_NAME="skilllynk-website-deployer"
export SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud config set project "$PROJECT_ID"
export PROJECT_NUMBER="$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')"
echo "Project number: $PROJECT_NUMBER"
```

## 3. Enable required APIs (idempotent — no-ops if already on from the mobile repo's setup)

```bash
gcloud services enable \
  iamcredentials.googleapis.com \
  sts.googleapis.com \
  firebasehosting.googleapis.com \
  cloudresourcemanager.googleapis.com
```

## 4. Create the deployer service account

Least-privilege, hosting-only — mirrors the mobile repo's deployer, kept as
a separate identity rather than reused so this pipeline's blast radius
stays scoped to this one site.

```bash
gcloud iam service-accounts create "$SA_NAME" \
  --display-name="GitHub Actions Deployer -- skill_lynk_website"

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/firebasehosting.admin"
```

## 5. Create the Workload Identity Pool + OIDC provider

The `attribute-condition` is the actual security boundary — only this exact
repo, only pushes to `main`, can ever mint a token that impersonates the
deployer service account.

```bash
gcloud iam workload-identity-pools create "$POOL_ID" \
  --location="global" \
  --display-name="skill_lynk_website GitHub Actions"

gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_ID" \
  --location="global" \
  --workload-identity-pool="$POOL_ID" \
  --display-name="GitHub Actions OIDC" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref" \
  --attribute-condition="assertion.repository == '${REPO}' && assertion.ref == 'refs/heads/main'"
```

## 6. Let the provider impersonate the service account

```bash
gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${REPO}"
```

## 7. Print the two values the workflow needs

```bash
echo "GCP_WORKLOAD_IDENTITY_PROVIDER=projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
echo "GCP_SERVICE_ACCOUNT=${SA_EMAIL}"
```

## 8. Add repo secrets on GitHub

`skill_lynk_website` → Settings → Secrets and variables → Actions → New
repository secret:

| Secret | Value |
|---|---|
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | printed in step 7 |
| `GCP_SERVICE_ACCOUNT` | printed in step 7 |

Nothing else — the static site has no `.env`/API keys of its own, and the
relocated Flutter app is built with whatever's already baked into this
repo (it doesn't call the backend directly; it's a marketing site).

## 9. Verify

Push to `main` (or merge a PR into it) and watch the Actions tab. The
"Authenticate to Google Cloud" step should complete with no key material
printed anywhere in the log. Once deployed, `https://skilllynk-www.web.app/`
should serve the new static landing page, and `https://skilllynk-www.web.app/app/`
should serve the relocated Flutter site.
