# SkillLynk Development Log & Architecture Guide

## 🚀 Project Overview
**SkillLynk** is an AI-based interview practice platform designed to help developers become industry-ready. It facilitates peer-to-peer and expert mock interviews using Agora RTC for real-time communication and a wallet-based credit system for scheduling.

---

## 🛠 Technical Stack
- **Framework:** Flutter (Web/Mobile/Desktop)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation:** GoRouter (`go_router`)
- **Styling:** Material 3 with Google Fonts (Inter)
- **Utilities:** `url_launcher` (for support emails), `google_fonts`
- **Hosting:** Firebase Hosting

---

## 📅 Completed Development Milestones

### 1. Brand Identity & Theming
- **Primary Color:** `#2563EB` (Trust & Intelligence)
- **Secondary Color:** `#22C55E` (Growth & Success)
- **Typography:** Inter (Modern & Technical)
- **Theme:** Centralized in `lib/core/theme/app_theme.dart`.

### 2. Landing Website (`/`)
- **Hero Section:** High-impact value proposition with "Get Started" and "Download" buttons.
- **Interactive Mockup:** A high-fidelity, Flutter-based 3x3 grid dashboard representing the app's internal UI with realistic interviewer profiles.
- **Feature Showcase:** Four-pillar display of Peer Interviews, Expert Feedback, Wallet System, and HD Video Calls.
- **How it Works:** Step-by-step guide from Sign Up to Success.
- **Navigation:** Smooth scrolling implemented for "Features" and "How it Works" sections.

### 3. Legal & Compliance
- **Privacy Policy (`/privacy`):** Comprehensive document covering Agora RTC usage, profile data, and wallet transactions.
- **Terms & Conditions (`/terms`):** Detailed terms including credit non-refundability and cancellation policies.
- **Contact Email:** Centralized as `skill.lynkk@gmail.com`.
- **Offline Files:** Created `PRIVACY_POLICY.md` and `TERMS_AND_CONDITIONS.md` for store submissions.

### 4. Support Integration
- **Contact Support Dialog:** A popup form that allows users to send structured support requests.
- **Email Bridge:** Integrated `url_launcher` to pre-fill emails to `skill.lynkk@gmail.com` directly from the website.

---

## 🚀 Deployment Instructions (Firebase)

**Changed 2026-08-25** — as part of the SkillLynk rebuild initiative (see `SkillLynk-Backend`'s `PRODUCT_ROADMAP.md`), this site's root domain is now a static HTML/CSS/JS landing page for real SEO (Flutter web renders nothing crawlable on first fetch). The old Flutter site (this repo's own `lib/`) was originally kept and relocated to `/app/` rather than deleted.

**Changed again 2026-09-05** — `/app/` now serves the *real* SkillLynk product instead: `SkillLynk-Mobile`'s Flutter web build (login, wallet, drives, everything), not this repo's old marketing-only Flutter site. This repo's own `lib/` source is left in place (unused, not part of any deploy) rather than deleted, same "keep, don't delete" precedent as before — but `.github/workflows/deploy-web.yml`/`preview-web.yml` no longer build it. See `firebase-deploy-setup.md` for the CI change (checks out `SkillLynk-Mobile` as a second repo via the new `MOBILE_REPO_PAT` secret) and the domain now wired up: `skillynk.in/` is the landing page, `skillynk.in/app/` is the product, and a returning logged-in visitor to `/` is redirected straight to `/app/` via a lightweight `sl_auth` cookie (`public/index.html`'s inline script + `SkillLynk-Mobile`'s `web_auth_flag_web.dart`).

`firebase.json`'s `public` now points at `public/` (not `build/web`) — that directory is the actual Firebase Hosting root:
```
public/
├── index.html          # new static landing page (source, not generated)
├── privacy/index.html  # static, ported from PRIVACY_POLICY.md
├── terms/index.html    # static, ported from TERMS_AND_CONDITIONS.md
├── assets/              # styles.css, site.js (hand-written, no build step)
├── robots.txt, sitemap.xml
└── app/                  # SkillLynk-Mobile's Flutter web build goes HERE -- gitignored, not source
```

**As of 2026-09-05, deploy is automated** — `.github/workflows/deploy-web.yml` runs on every push to `main` (also `workflow_dispatch`): it checks out `SkillLynk-Mobile` as a second repo (needs the `MOBILE_REPO_PAT` secret, see `firebase-deploy-setup.md`), builds its Flutter web target with `--base-href /app/`, copies the output into `public/app/`, then deploys. Pushing to this repo's `main` alone does **not** pick up a newer `SkillLynk-Mobile` build automatically yet — that cross-repo trigger isn't wired up, so a mobile-only change needs a manual `workflow_dispatch` re-run here to actually redeploy.

To deploy manually (matches what CI does, useful for local testing):

1. **Clone/pull `SkillLynk-Mobile` separately** and build its web target with the base href this domain needs:
   ```bash
   flutter build web --release --base-href /app/
   ```
2. **Copy that build output into *this* repo's `public/app/`:**
   ```bash
   rm -rf public/app && cp -r <path-to-skilllynk-mobile>/build/web public/app
   ```
3. **Deploy everything (static site + the real product) in one shot:**
   ```bash
   firebase deploy --only hosting
   ```

The static landing page itself (`public/index.html`, `public/privacy/`, `public/terms/`) needs no build step — edit and deploy directly. Only the `/app/` subtree needs the Flutter build step above, and it now builds from `SkillLynk-Mobile`'s source, not this repo's own `lib/`.

---

## 📁 Key File Structure
- `lib/core/router/`: Routing configuration.
- `lib/features/landing/`: Landing page screens and sections.
- `lib/features/legal/`: Privacy and Terms screens.
- `lib/features/support/`: Contact dialog and email logic.
- `lib/shared/widgets/`: Reusable Header and Footer components.

---

**Last Updated:** April 11, 2026
**Contact:** skill.lynkk@gmail.com
