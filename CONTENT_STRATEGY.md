# Content Strategy — Site IA & Keyword Map

Sprint 2 deliverable of the SkillLynk rebuild initiative (see `SkillLynk-Backend`'s `PRODUCT_ROADMAP.md`). Written to work regardless of whether the site stays static HTML or eventually moves to Next.js — it's a target structure and topic list, not framework-specific.

## Current state vs. target

**This table was stale as of 2026-09-12** — several rows below marked "Not built" when this doc was first written have since shipped (see git log: `7c0cd1d` first 3 blog posts, `08680e5` for-companies + download pages). Corrected here during the pre-launch SEO pass; keep this table honest going forward rather than letting it drift again.

| Page | Status |
|---|---|
| `/` (Home) | ✅ Live — static |
| `/privacy/`, `/terms/` | ✅ Live — static, no OG image (low priority — nobody shares a privacy policy link) |
| `/app/` | **Reclassified 2026-09-12.** No longer "archived" — this now serves the real product (`SkillLynk-Mobile`'s Flutter web build, see `SKILL.md`'s deploy section). Correctly `Disallow`'d in `robots.txt` as of this pass — it's the authenticated app, not marketing content, and crawling a large SPA build wastes crawl budget for zero SEO benefit. |
| `/how-it-works/` | Currently an anchor section on Home (`#how-it-works`), not a standalone page — fine for now, split out once it needs its own search-intent targeting (see keyword map) |
| `/for-companies/` | ✅ **Live** (shipped `08680e5`). B2B landing page. Has OG/Twitter card tags as of 2026-09-12. |
| `/blog/` | ✅ **Live** (shipped `7c0cd1d`, extended 2026-09-12/13/16/17). 7 posts as of this pass — see "Published posts" below. Still hand-written static (see "Decision" below, now resolved for launch). |
| `/blog/interview-readiness-score/` | ✅ **Added 2026-09-12** — the "interview readiness score" keyword row below, previously unwritten. |
| `/blog/why-we-built-skilllynk/` | ✅ **Added 2026-09-13** — launch-week narrative post (not tied to a specific SEO keyword row; part of the Launch Week Playbook's Day 1 "why we built SkillLynk / a how-to / a feature deep-dive" content plan, see that Artifact and the "Launch Week Content Kit" companion). |
| `/blog/daily-coding-challenge-practice/` | ✅ **Added 2026-09-16** — the launch-week "how-to" post (blog post #2), and fills the `daily coding challenge practice` keyword row below. |
| `/blog/dsa-interview-prep/` | ✅ **Added 2026-09-17** — the launch-week "feature deep-dive" post (blog post #3), and fills the `DSA interview prep` keyword row below. |
| `/passport/[slug]` (public Skill Passport pages) | **Still not built here.** Backend already server-renders `GET /passport/public/:slug` with its own OG tags (see `SkillLynk-Backend`'s CLAUDE.md, "Skill Passport" section) — a shared passport link already works and is already indexable on its own, it just isn't cross-linked from this site's nav/footer. Lower priority than it looks: each passport URL is one specific candidate's, so there's no single static page to add here — the real fix (linking to "yours" from the site) has to happen in the mobile app's own share flow, not this repo. |
| `/download/` | ✅ **Live** (shipped `08680e5`). Has OG/Twitter card tags as of 2026-09-12. iOS messaging still absent (no iOS release yet — see `SkillLynk-Backend`'s referral-link section on why). |

## Keyword map

15 target topics, each mapped to real product surface — no keyword here targets something the product doesn't actually do.

| Keyword / topic | Intent | Funnel stage | Content type | Notes |
|---|---|---|---|---|
| AI interview practice | Informational/navigational | Top | Home (already targeted) | Primary term, already in title/H1/meta |
| AI mock interview | Informational/navigational | Top | Home + a dedicated blog post ("What an AI mock interview actually feels like") | High intent, competitive — needs the blog post to rank on long-tail variants |
| technical interview practice online | Informational | Top | Home | Already covered by hero copy |
| system design interview practice | Informational | Mid | Blog post | Ties directly to the "System Design" topic tag already shown in the passport mockup on Home |
| coding interview practice free | Transactional | Mid | Blog post + Home CTA | "Free" is a real, honest claim (peer interviews + daily practice are free) — lead with it |
| Skill Passport verified activity | Navigational/branded | Bottom | The "interview readiness score" post below + public passport pages | **Row corrected 2026-09-12** — this used to say "verified score," but the backend dropped a single `verified_score` from the public card entirely (2026-09-06 redesign) in favor of activity counts (topics demonstrated, interviews completed, coding problems solved, drives completed). Don't target "verified score" as a keyword going forward — it no longer describes the real product and would set the wrong expectation. |
| hiring drive assessment platform | Commercial (B2B) | Bottom | `/for-companies/` (now live) | Live as of `08680e5` |
| daily coding challenge practice | Informational | Mid | ✅ Written 2026-09-16 — `/blog/daily-coding-challenge-practice/` | Ties to the real Daily Coding Challenge feature: shared daily problem, run/submit split, streak integration |
| interview readiness score | Informational | Mid | ✅ Written 2026-09-12 — `/blog/interview-readiness-score/` | Deliberately answers the search intent honestly: explains why SkillLynk doesn't reduce readiness to one gamified number, and what it shows instead |
| behavioral interview practice AI | Informational | Mid | Blog post | AI voice interviews handle this; not currently called out distinctly from technical prep |
| mock interview with AI voice interviewer | Informational/navigational | Top | Home (already targeted) + blog post going deeper | |
| DSA interview prep | Informational | Mid | ✅ Written 2026-09-17 — `/blog/dsa-interview-prep/` | Common competitor-adjacent term (LeetCode audience) — a real acquisition wedge; ties to Target Interview's JD-seeded, language-matched coding rounds |
| SQL interview questions practice | Informational | Long-tail | Blog post | Ties to the "SQL & Databases" topic already surfaced in the passport mockup |
| resume ATS score checker | Transactional | Mid | Blog post + link to the in-app Resume Review feature | Real, free, standalone feature (`POST /resume-review`) with almost no current external surface |
| peer mock interview practice free | Transactional | Top | Home (already targeted) | |

## Decision: hand-written static, for now (resolved 2026-09-12)

This was left open pending a first batch of posts to prove out the keyword map — that's done (7 posts live). **Staying hand-written static through public launch**: a Next.js migration is a real new codebase, not something to take on in launch week, and 7 posts is still short of the "~10, getting painful" ceiling flagged below. Revisit post-launch once there's an actual publishing cadence established (the Launch Week Playbook and the Daily Streak Playbook both call for ongoing content) and the manual-per-post cost is a felt problem, not a hypothetical one.

- **Hand-written static** (current pattern — one `public/blog/<slug>/index.html` per post, a `public/blog/index.html` listing page): works today with zero new infrastructure, but every post is fully manual (no templating, no RSS, no tag pages) — fine for 3-5 posts, painful past ~10.
- **Next.js migration** (the originally-planned Phase 1 Sprint 3-5 path): MDX + ISR gives templating, an RSS feed, and tag/category pages for free, and unlocks the data-driven public Skill Passport pages properly — but it's a real new codebase, not a content task. Revisit this once post volume actually justifies it.

## Not done in this pass (2026-09-12 SEO audit)

- **Blog RSS feed** — no templating engine here to generate one from; would need either a hand-maintained `feed.xml` or the Next.js migration above.
- **`/passport/[slug]` cross-linking** from this site — see the table above; the actual fix belongs in the mobile app's share flow, not here.
- **`SQL interview questions practice` blog post** — the one remaining keyword-map row without a post. `daily coding challenge practice` and `DSA interview prep` are both now written (blog posts #2 and #3 from the Launch Week Content Kit, shipped 2026-09-16/17).
- **OG images on `/privacy/` and `/terms/`** — deliberately skipped, low value (nobody shares a privacy policy link socially).
