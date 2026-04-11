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

To deploy the latest version of the website:

1. **Build the Web Release:**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase:**
   ```bash
   firebase deploy --only hosting
   ```

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
