# Content Strategy — Site IA & Keyword Map

Sprint 2 deliverable of the SkillLynk rebuild initiative (see `SkillLynk-Backend`'s `PRODUCT_ROADMAP.md`). Written to work regardless of whether the site stays static HTML or eventually moves to Next.js — it's a target structure and topic list, not framework-specific.

## Current state vs. target

| Page | Status |
|---|---|
| `/` (Home) | ✅ Live — static |
| `/privacy/`, `/terms/` | ✅ Live — static |
| `/app/` | Archived Flutter site, deliberately unlinked/not indexed |
| `/how-it-works/` | Currently an anchor section on Home (`#how-it-works`), not a standalone page — fine for now, split out once it needs its own search-intent targeting (see keyword map) |
| `/for-companies/` | **Not built.** B2B landing page linking to `skilllynk-portal` (the company self-serve portal). Real gap — companies searching for an assessment platform have nowhere to land. |
| `/blog/` | **Not built.** This is the actual content engine — see "Content type" column below. Needs either hand-written static posts (works today, doesn't scale past a handful) or the Next.js migration (see decision note). |
| `/passport/[slug]` (public Skill Passport pages) | **Not built.** Backend already server-renders `GET /passport/public/:slug` — this site doesn't yet surface/link to it. Real, low-effort win: even a single static page linking out, or a proper branded wrapper, gets these indexed. |
| `/download/` | **Not built.** Smart App/Play Store redirect, mirroring the backend's `/link/join` logic. Currently the site just links straight to the Play Store from every CTA — works, but a dedicated page is more shareable and better for the (currently missing) iOS messaging. |

## Keyword map

15 target topics, each mapped to real product surface — no keyword here targets something the product doesn't actually do.

| Keyword / topic | Intent | Funnel stage | Content type | Notes |
|---|---|---|---|---|
| AI interview practice | Informational/navigational | Top | Home (already targeted) | Primary term, already in title/H1/meta |
| AI mock interview | Informational/navigational | Top | Home + a dedicated blog post ("What an AI mock interview actually feels like") | High intent, competitive — needs the blog post to rank on long-tail variants |
| technical interview practice online | Informational | Top | Home | Already covered by hero copy |
| system design interview practice | Informational | Mid | Blog post | Ties directly to the "System Design" topic tag already shown in the passport mockup on Home |
| coding interview practice free | Transactional | Mid | Blog post + Home CTA | "Free" is a real, honest claim (peer interviews + daily practice are free) — lead with it |
| Skill Passport verified score | Navigational/branded | Bottom | `/passport/` explainer + public passport pages | The actual differentiator; currently under-indexed since no public passport pages exist yet |
| hiring drive assessment platform | Commercial (B2B) | Bottom | `/for-companies/` (not built) | Zero current coverage — this is the biggest structural gap in the current IA |
| daily coding challenge practice | Informational | Mid | Blog post | Ties to the real Daily Coding Challenge feature |
| interview readiness score | Informational | Mid | Blog post explaining Skill Passport + growth dashboard concept | Novel term, low competition — worth owning |
| behavioral interview practice AI | Informational | Mid | Blog post | AI voice interviews handle this; not currently called out distinctly from technical prep |
| mock interview with AI voice interviewer | Informational/navigational | Top | Home (already targeted) + blog post going deeper | |
| DSA interview prep | Informational | Mid | Blog post | Common competitor-adjacent term (LeetCode audience) — a real acquisition wedge |
| SQL interview questions practice | Informational | Long-tail | Blog post | Ties to the "SQL & Databases" topic already surfaced in the passport mockup |
| resume ATS score checker | Transactional | Mid | Blog post + link to the in-app Resume Review feature | Real, free, standalone feature (`POST /resume-review`) with almost no current external surface |
| peer mock interview practice free | Transactional | Top | Home (already targeted) | |

## Decision needed: does the blog stay hand-written static, or wait for Next.js?

Not resolved in this pass — flagging rather than deciding unilaterally, since it changes real scope:

- **Hand-written static** (extend the current pattern — one `public/blog/<slug>/index.html` per post, a `public/blog/index.html` listing page): works today with zero new infrastructure, but every post is fully manual (no templating, no RSS, no tag pages) — fine for 3-5 posts, painful past ~10.
- **Next.js migration** (the originally-planned Phase 1 Sprint 3-5 path): MDX + ISR gives templating, an RSS feed, and tag/category pages for free, and unlocks the data-driven public Skill Passport pages properly — but it's a real new codebase, not a content task.

Recommend deciding this once there's an actual first batch of posts to write (2-3 posts hand-written now proves out the keyword map before investing in a framework for it) — but this is the user's call given it changes how much of Phase 1 is still needed.
