#!/usr/bin/env python3
"""Regenerate the blog's internal links and the sitemap from blog/index.html.

Run after adding or editing a post:  python3 scripts/update_blog_links.py

The post cards in public/blog/index.html are the source of truth (newest
first). From them this script writes:
  - a "Keep reading" block at the end of every post (3 related posts),
  - a "From the blog" section on the homepage (3 newest posts),
  - public/sitemap.xml with a <lastmod> for every URL.

Each generated block sits between <!-- name:start --> / <!-- name:end -->
markers and is replaced on every run, so the script is safe to re-run.

Why: Google Search Console listed every post as "Discovered - currently not
indexed". The homepage linked only to /blog/ and no post linked to another,
so each post had a single internal link. Google also ignores <priority> and
<changefreq> but does use <lastmod>.
"""
import datetime
import html
import pathlib
import re
import subprocess

ROOT = pathlib.Path(__file__).resolve().parent.parent
PUBLIC = ROOT / "public"
SITE = "https://skillynk.in"

# Hand-picked related posts; anything not listed falls back to the newest
# other posts.
RELATED = {
    "hr-interview-questions-for-freshers": ["behavioral-interview-questions", "what-an-ai-mock-interview-feels-like", "free-resume-ats-checker"],
    "behavioral-interview-questions": ["hr-interview-questions-for-freshers", "what-an-ai-mock-interview-feels-like", "interview-readiness-score"],
    "sql-interview-questions": ["dsa-interview-prep", "daily-coding-challenge-practice", "what-an-ai-mock-interview-feels-like"],
    "dsa-interview-prep": ["sql-interview-questions", "daily-coding-challenge-practice", "how-to-practice-system-design-interviews"],
    "daily-coding-challenge-practice": ["dsa-interview-prep", "sql-interview-questions", "interview-readiness-score"],
    "why-we-built-skilllynk": ["what-an-ai-mock-interview-feels-like", "interview-readiness-score", "dsa-interview-prep"],
    "interview-readiness-score": ["behavioral-interview-questions", "what-an-ai-mock-interview-feels-like", "daily-coding-challenge-practice"],
    "what-an-ai-mock-interview-feels-like": ["behavioral-interview-questions", "how-to-practice-system-design-interviews", "free-resume-ats-checker"],
    "how-to-practice-system-design-interviews": ["what-an-ai-mock-interview-feels-like", "dsa-interview-prep", "daily-coding-challenge-practice"],
    "free-resume-ats-checker": ["hr-interview-questions-for-freshers", "dsa-interview-prep", "what-an-ai-mock-interview-feels-like"],
}

# Non-blog pages in the sitemap, in order.
STATIC_PAGES = ["", "for-companies/", "download/", "privacy/", "terms/"]

CARD_RE = re.compile(
    r'<a class="post-card" href="/blog/(?P<slug>[^/"]+)/">\s*'
    r'<span class="tag">(?P<tag>.*?)</span>\s*'
    r'<h3>(?P<title>.*?)</h3>\s*'
    r'<p>(?P<desc>.*?)</p>\s*'
    r'<span class="meta-text">(?P<meta>.*?)</span>\s*</a>',
    re.S,
)


def read_posts():
    index = (PUBLIC / "blog" / "index.html").read_text()
    posts = [m.groupdict() for m in CARD_RE.finditer(index)]
    if not posts:
        raise SystemExit("No post cards found in public/blog/index.html")
    for post in posts:
        page = (PUBLIC / "blog" / post["slug"] / "index.html").read_text()
        date = re.search(r'"datePublished":\s*"([0-9-]+)"', page)
        if not date:
            raise SystemExit(f"{post['slug']}: no datePublished in its JSON-LD")
        post["date"] = date.group(1)
    return posts


def card(post, heading="h3"):
    return (
        f'<a class="post-card" href="/blog/{post["slug"]}/">\n'
        f'  <span class="tag">{post["tag"]}</span>\n'
        f'  <{heading}>{post["title"]}</{heading}>\n'
        f'  <p>{post["desc"]}</p>\n'
        f'  <span class="meta-text">{post["meta"]}</span>\n'
        f'</a>'
    )


def replace_block(text, name, block, insert_before):
    """Replace <!-- name:start -->...<!-- name:end -->, or insert it before
    the first occurrence of `insert_before`."""
    wrapped = f"<!-- {name}:start -->\n{block}\n<!-- {name}:end -->"
    pattern = re.compile(rf"<!-- {name}:start -->.*?<!-- {name}:end -->", re.S)
    if pattern.search(text):
        return pattern.sub(lambda _: wrapped, text, count=1)
    if insert_before not in text:
        raise SystemExit(f"Couldn't place the {name} block: {insert_before!r} not found")
    return text.replace(insert_before, wrapped + "\n" + insert_before, 1)


def indent(text, spaces):
    pad = " " * spaces
    return "\n".join(pad + line if line else line for line in text.splitlines())


def update_posts(posts):
    by_slug = {p["slug"]: p for p in posts}
    for post in posts:
        picks = [s for s in RELATED.get(post["slug"], []) if s in by_slug and s != post["slug"]]
        for other in posts:
            if len(picks) >= 3:
                break
            if other["slug"] != post["slug"] and other["slug"] not in picks:
                picks.append(other["slug"])
        cards = "\n".join(indent(card(by_slug[s], "h3"), 6) for s in picks[:3])
        block = (
            '    <section class="related-posts" aria-labelledby="related-heading">\n'
            '      <h2 id="related-heading">Keep reading</h2>\n'
            '      <div class="related-grid">\n'
            f"{indent(cards, 2)}\n"
            "      </div>\n"
            "    </section>"
        )
        path = PUBLIC / "blog" / post["slug"] / "index.html"
        text = path.read_text()
        # Goes after the post's CTA box, at the end of the article body.
        text = replace_block(text, "related", block, "  </div>\n</main>")
        path.write_text(text)


def update_homepage(posts):
    cards = "\n".join(indent(card(p), 8) for p in posts[:3])
    block = (
        '  <section class="section" id="from-the-blog">\n'
        '    <div class="wrap">\n'
        '      <div class="section-head">\n'
        '        <span class="eyebrow">From the blog</span>\n'
        "        <h2>Practice notes, not filler</h2>\n"
        "        <p>What actually works in interview prep, from the team building SkillLynk.</p>\n"
        "      </div>\n"
        '      <div class="blog-grid">\n'
        f"{cards}\n"
        "      </div>\n"
        '      <p class="section-more"><a href="/blog/">All posts →</a></p>\n'
        "    </div>\n"
        "  </section>"
    )
    path = PUBLIC / "index.html"
    text = path.read_text()
    text = replace_block(text, "from-the-blog", block, '  <section class="cta-section">')
    path.write_text(text)


def last_commit_date(path):
    """Date of the last commit touching `path`; today if it has uncommitted changes."""
    rel = str(path.relative_to(ROOT))
    dirty = subprocess.run(["git", "status", "--porcelain", "--", rel], cwd=ROOT, capture_output=True, text=True).stdout.strip()
    if dirty:
        return datetime.date.today().isoformat()
    out = subprocess.run(["git", "log", "-1", "--format=%cs", "--", rel], cwd=ROOT, capture_output=True, text=True).stdout.strip()
    return out or datetime.date.today().isoformat()


def update_sitemap(posts):
    entries = []
    # The homepage lastmod is taken after update_homepage has run, so a new
    # post (which changes the homepage's blog section) bumps it too.
    for page in STATIC_PAGES[:1]:
        entries.append((SITE + "/" + page, last_commit_date(PUBLIC / page / "index.html")))
    entries.append((SITE + "/blog/", max(p["date"] for p in posts)))
    for post in posts:
        entries.append((f"{SITE}/blog/{post['slug']}/", post["date"]))
    for page in STATIC_PAGES[1:]:
        entries.append((SITE + "/" + page, last_commit_date(PUBLIC / page / "index.html")))

    lines = ['<?xml version="1.0" encoding="UTF-8"?>', '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">']
    for loc, lastmod in entries:
        lines += ["  <url>", f"    <loc>{html.escape(loc)}</loc>", f"    <lastmod>{lastmod}</lastmod>", "  </url>"]
    lines.append("</urlset>")
    (PUBLIC / "sitemap.xml").write_text("\n".join(lines) + "\n")


def main():
    posts = read_posts()
    update_posts(posts)
    update_homepage(posts)
    update_sitemap(posts)
    print(f"Updated {len(posts)} posts, the homepage and sitemap.xml")


if __name__ == "__main__":
    main()
