# Firebase Hosting Deploy — One-Time Setup

`.github/workflows/deploy-web.yml` builds the static marketing site (and the
relocated Flutter app under `/app/`) and deploys to a **new, dedicated**
Firebase Hosting site on every push to `main`. Same Workload Identity
Federation (OIDC) approach already proven in `SkillLynk-Mobile`'s
`deploy-web.yml`: no service account JSON key is ever generated, stored, or
rotated.

**Deliberately a *new* Hosting site, not `skill-lynk` (the mobile web PWA's
existing site)** — the two are different products and were about to collide
on the same domain by accident. Also deliberately a **new, separate**
Workload Identity pool/provider rather than editing the mobile repo's
existing one — narrower blast radius.

## Status (2026-08-28)

Partially run already — some steps succeeded, some failed and need a retry
with a fix. Reflected below so re-running this doc top-to-bottom is safe
(every `gcloud`/`firebase` command here is idempotent or checked).

| Step | State |
|---|---|
| Hosting site | ✅ Done. `skilllynk-www` was rejected as an invalid site id (Firebase's naming rules); the actual site is **`skilllynk-fa13b`** → `https://skilllynk-fa13b.web.app`. Every reference in this repo (`firebase.json`, `.firebaserc`, `public/*.html`, `sitemap.xml`, `robots.txt`) has been updated to match — don't recreate the site, don't rename it. |
| APIs enabled | ✅ Done (implied by later steps succeeding). |
| Service account | ✅ Created (`skilllynk-website-deployer@skill-lynk-app.iam.gserviceaccount.com`). |
| Project IAM binding (`roles/firebasehosting.admin`) | ❌ Failed — hit a propagation race (the service account didn't exist yet at that exact instant). **Just needs a retry**, not a fix. |
| Workload Identity Pool | ❌ Failed — display name `"skill_lynk_website GitHub Actions"` is 34 characters, GCP's limit is 32. **Fixed below** (`"SkillLynk Website Deploy"`, 24 chars). |
| OIDC provider | ❌ Failed as a consequence of the pool not existing — will work once the pool above is created. |
| SA ↔ pool IAM binding | ❌ Failed, same reason — will work once the pool exists. |
| GitHub secrets | ✅ Added by the user. Values don't need to change — same pool/provider *names* were used, only their creation failed, so the already-added secrets will start working once the resources below actually exist. |
| First deploy run | ❌ Failed (`invalid_target` — pool/provider don't exist), exactly as expected given the above. |

**Everything below is now a retry script for just the failed steps** — the
first two sections (create site, enable APIs) are done, skip them.

## Prerequisites

```bash
export PROJECT_ID="skill-lynk-app"
export PROJECT_NUMBER="114101939161"
export REPO="NightMare8587/skill_lynk_website"   # exact owner/repo, case-sensitive
export POOL_ID="skilllynk-website-pool"
export PROVIDER_ID="github-actions-provider"
export SA_NAME="skilllynk-website-deployer"
export SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud config set project "$PROJECT_ID"
```

## 1. Retry: grant the service account Hosting admin

```bash
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/firebasehosting.admin"
```

## 2. Fixed: create the Workload Identity Pool (display name ≤32 chars)

```bash
gcloud iam workload-identity-pools create "$POOL_ID" \
  --location="global" \
  --display-name="SkillLynk Website Deploy"
```

## 3. Create the OIDC provider

The `attribute-condition` is the actual security boundary — only this exact
repo, only pushes to `main`, can ever mint a token that impersonates the
deployer service account.

```bash
gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_ID" \
  --location="global" \
  --workload-identity-pool="$POOL_ID" \
  --display-name="GitHub Actions OIDC" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref" \
  --attribute-condition="assertion.repository == '${REPO}' && assertion.ref == 'refs/heads/main'"
```

## 4. Let the provider impersonate the service account

```bash
gcloud iam service-accounts add-iam-policy-binding "$SA_EMAIL" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${REPO}"
```

## 5. Verify the values match what's already in GitHub secrets

```bash
echo "GCP_WORKLOAD_IDENTITY_PROVIDER=projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
echo "GCP_SERVICE_ACCOUNT=${SA_EMAIL}"
```

These should be identical to what's already saved as `GCP_WORKLOAD_IDENTITY_PROVIDER`/`GCP_SERVICE_ACCOUNT` in the repo's Actions secrets — no need to re-add them if so.

## 6. Re-trigger the deploy

Either push an empty-ish commit, or use the Actions tab → "Deploy to Firebase
Hosting" → Run workflow (branch `main`). The "Authenticate to Google Cloud"
step should complete with no key material printed anywhere in the log.
Once deployed, `https://skilllynk-fa13b.web.app/` serves the static landing
page, and `https://skilllynk-fa13b.web.app/app/` serves the relocated
Flutter site.
