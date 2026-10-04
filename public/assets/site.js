const yearEl = document.getElementById('year');
if (yearEl) yearEl.textContent = new Date().getFullYear();

const menuToggle = document.getElementById('menuToggle');
const mobileNav = document.getElementById('mobileNav');
if (menuToggle && mobileNav) {
  menuToggle.addEventListener('click', () => {
    const open = mobileNav.style.display === 'flex';
    mobileNav.style.display = open ? 'none' : 'flex';
    menuToggle.setAttribute('aria-expanded', String(!open));
  });
  mobileNav.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      mobileNav.style.display = 'none';
      menuToggle.setAttribute('aria-expanded', 'false');
    });
  });
}

// Email links. A mailto: link does nothing on a computer with no mail app
// set up (common on Macs and on work PCs), so clicking "Contact" looked
// broken. Every email link now copies the address and shows a small panel
// with an "Open in Gmail" button, while still trying the mail app.
const SUPPORT_EMAIL = 'skill.lynkk@gmail.com';

function gmailComposeUrl(to, subject, body) {
  const params = new URLSearchParams({ view: 'cm', fs: '1', to });
  if (subject) params.set('su', subject);
  if (body) params.set('body', body);
  return `https://mail.google.com/mail/?${params.toString()}`;
}

function showEmailPanel(to, subject, body) {
  document.getElementById('emailPanel')?.remove();
  const panel = document.createElement('div');
  panel.id = 'emailPanel';
  panel.setAttribute('role', 'dialog');
  panel.setAttribute('aria-label', 'Contact SkillLynk');
  panel.style.cssText = 'position:fixed;left:50%;bottom:24px;transform:translateX(-50%);z-index:1000;'
    + 'width:min(420px,calc(100vw - 32px));box-sizing:border-box;padding:18px 18px 16px;border-radius:14px;'
    + 'background:#18181B;color:#FAFAFA;border:1px solid #3F3F46;box-shadow:0 12px 40px rgba(0,0,0,.45);'
    + 'font-family:inherit;font-size:14px;line-height:1.45;';
  panel.innerHTML = `
    <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:12px;">
      <div>
        <div style="font-weight:600;margin-bottom:4px;">Email us</div>
        <div style="color:#A1A1AA;"><span id="emailPanelAddress" style="color:#FAFAFA;"></span> <span id="emailPanelCopied" style="color:#34D399;"></span></div>
      </div>
      <button type="button" aria-label="Close" style="background:none;border:0;color:#A1A1AA;font-size:20px;line-height:1;cursor:pointer;padding:0 2px;">×</button>
    </div>
    <div style="display:flex;gap:10px;margin-top:14px;flex-wrap:wrap;">
      <a id="emailPanelGmail" target="_blank" rel="noopener" style="flex:1;min-width:140px;text-align:center;padding:10px 14px;border-radius:10px;background:#34D399;color:#052E1C;font-weight:600;text-decoration:none;">Open in Gmail</a>
      <button type="button" id="emailPanelCopy" style="flex:1;min-width:120px;padding:10px 14px;border-radius:10px;background:transparent;color:#FAFAFA;border:1px solid #3F3F46;font-weight:600;cursor:pointer;font:inherit;">Copy address</button>
    </div>`;
  panel.querySelector('#emailPanelAddress').textContent = to;
  panel.querySelector('#emailPanelGmail').href = gmailComposeUrl(to, subject, body);
  const copied = panel.querySelector('#emailPanelCopied');
  const copy = () => navigator.clipboard?.writeText(to).then(() => { copied.textContent = '· copied'; }).catch(() => {});
  panel.querySelector('#emailPanelCopy').addEventListener('click', copy);
  panel.querySelector('button[aria-label="Close"]').addEventListener('click', () => panel.remove());
  document.body.appendChild(panel);
  copy();
}

window.openEmail = function openEmail(to, subject, body) {
  showEmailPanel(to || SUPPORT_EMAIL, subject, body);
  const params = new URLSearchParams();
  if (subject) params.set('subject', subject);
  if (body) params.set('body', body);
  const query = params.toString().replace(/\+/g, '%20');
  window.location.href = `mailto:${to || SUPPORT_EMAIL}${query ? `?${query}` : ''}`;
};

document.addEventListener('click', (event) => {
  const link = event.target.closest && event.target.closest('a[href^="mailto:"]');
  if (!link) return;
  event.preventDefault();
  const url = new URL(link.href);
  window.openEmail(decodeURIComponent(url.pathname), url.searchParams.get('subject'), url.searchParams.get('body'));
});

// On Android, "Get it on Google Play" opens the app when it's already
// installed: an intent link targets the app's https link filter and falls
// back to the store listing when the app isn't there.
(function () {
  if (!/Android/i.test(navigator.userAgent || '')) return;
  const PKG = 'com.consumers.skilllynkmobile.skilllynkmobile';
  document.querySelectorAll('a[href*="play.google.com/store/apps/details"]').forEach((a) => {
    if (a.href.indexOf(PKG) === -1) return;
    a.href = 'intent://api.skillynk.in/v2/link/open#Intent;scheme=https;package=' + PKG +
      ';S.browser_fallback_url=' + encodeURIComponent(a.href) + ';end';
  });
})();
