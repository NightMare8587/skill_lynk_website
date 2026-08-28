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
| Project IAM binding (`roles/firebasehosting.admin`) | ✅ Retried successfully. |
| Workload Identity Pool | ✅ Retried successfully with the shortened display name. |
| OIDC provider | ✅ Created successfully once the pool existed. |
| SA ↔ pool IAM binding | ✅ Created successfully. |
| GitHub secrets | ✅ Added by the user — confirmed working (see next row). |
| WIF authentication | ✅ **Confirmed working** — a real workflow run's "Authenticate to Google Cloud" step completed successfully with no key material logged. The whole WIF/impersonation chain is sound. |
| `firebase-tools deploy` step (production, push to `main`) | ✅ Fixed — was a real `firebase-tools` 15.22.2+ regression breaking ADC/WIF auth ([firebase-tools#10716](https://github.com/firebase/firebase-tools/issues/10716), [#10726](https://github.com/firebase/firebase-tools/issues/10726)), pinned to `15.22.1` in `deploy-web.yml`. **Confirmed live and green.** |
| PR preview channel (`preview-web.yml`, added 2026-08-28) | ❌ Failed on its first real test (PR #1): `unauthorized_client: The given credential is rejected by the attribute condition`. Root cause: the WI provider's `attribute-condition` only allows `assertion.ref == 'refs/heads/main'` — correct for `deploy-web.yml` (push-to-main only, by design), but a `pull_request` event's ref is `refs/pull/N/merge`, never `refs/heads/main`, so it's structurally never going to match. **One more command needed** — see "Widen the provider for PR previews" below. |

**One command still needed**, for the PR-preview workflow specifically — everything else (including the production deploy) is done and confirmed working.

## Widen the provider for PR previews

```bash
gcloud iam workload-identity-pools providers update-oidc github-actions-provider \
  --location="global" \
  --workload-identity-pool="skilllynk-website-pool" \
  --attribute-condition="assertion.repository == 'NightMare8587/skill_lynk_website' && (assertion.ref == 'refs/heads/main' || (assertion.event_name == 'pull_request' \&\& assertion.base_ref == 'main'))"
```

Still scoped tightly — only this repo, and only either a push to `main` or a PR whose *base* is `main` (not just any PR from anywhere). `update-oidc` on an existing provider replaces its condition in place; no need to delete/recreate anything. After running this, re-trigger the PR preview (push a commit to the PR branch, or close/reopen it) and it should get past the auth step.

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
