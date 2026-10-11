/*
 * Ad tracking for skillynk.in and the web app at /app/ (one file, one origin,
 * so what is saved on the marketing site is there when the app opens).
 *
 * 1. Saves where a visitor came from (utm_* and Meta's fbclid) the first time
 *    they arrive from an ad, for 30 days. The app sends it to the backend at
 *    signup (window.sklAttribution), which stores it and reports signups,
 *    activation and revenue per campaign.
 * 2. Loads the Meta Pixel and sends PageView and Lead (clicks on "Start free"
 *    and the Play Store button) once the visitor has accepted cookies.
 *    Signup, activation and purchase are sent from the backend (Conversions
 *    API), not from here.
 *
 * Paste the Pixel ID below (Meta Events Manager > Data sources). Empty means
 * the pixel stays off and only the first-party attribution above runs.
 */
(function () {
  var META_PIXEL_ID = '1902187317575606';

  var STORE_KEY = 'skl_attr';
  var CONSENT_KEY = 'skl_consent';
  var TTL_MS = 30 * 24 * 60 * 60 * 1000;
  var UTM_FIELDS = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content', 'utm_term'];

  function read(key) {
    try { return JSON.parse(localStorage.getItem(key)); } catch (e) { return null; }
  }
  function write(key, value) {
    try { localStorage.setItem(key, JSON.stringify(value)); } catch (e) { /* private mode */ }
  }
  function cookie(name) {
    var match = document.cookie.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
    return match ? decodeURIComponent(match[1]) : null;
  }

  // --- 1. First-touch attribution -------------------------------------
  function capture() {
    var query = new URLSearchParams(window.location.search);
    var found = {};
    UTM_FIELDS.forEach(function (f) { if (query.get(f)) found[f] = query.get(f); });
    if (query.get('fbclid')) found.fbclid = query.get('fbclid');
    if (!Object.keys(found).length) return;

    var existing = read(STORE_KEY);
    var fresh = existing && existing.saved_at && Date.now() - existing.saved_at < TTL_MS;
    // First touch wins, unless what we hold has no campaign and this does.
    if (fresh && (existing.utm_source || existing.fbclid)) return;

    found.landing_url = (window.location.origin + window.location.pathname).slice(0, 500);
    found.referrer = (document.referrer || '').slice(0, 500);
    found.saved_at = Date.now();
    write(STORE_KEY, found);

    // Meta's browser click id, in the format its pixel and Conversions API use.
    if (found.fbclid && !cookie('_fbc')) {
      document.cookie = '_fbc=fb.1.' + Date.now() + '.' + encodeURIComponent(found.fbclid)
        + '; path=/; max-age=' + 90 * 24 * 60 * 60 + '; SameSite=Lax';
    }
  }

  // What the app sends at signup (null when the visitor didn't come from a tagged link).
  window.sklAttribution = function () {
    var saved = read(STORE_KEY);
    if (!saved || !saved.saved_at || Date.now() - saved.saved_at >= TTL_MS) return null;
    var out = { client: 'web' };
    UTM_FIELDS.concat(['fbclid', 'landing_url', 'referrer']).forEach(function (f) { if (saved[f]) out[f] = saved[f]; });
    var fbp = cookie('_fbp');
    var fbc = cookie('_fbc');
    if (fbp) out.fbp = fbp;
    if (fbc) out.fbc = fbc;
    return out;
  };

  capture();

  // Android installs: pass the campaign through the Play Store's referrer so
  // the app can attribute them too.
  function tagPlayLinks() {
    var saved = window.sklAttribution();
    if (!saved) return;
    var parts = [];
    UTM_FIELDS.concat(['fbclid']).forEach(function (f) { if (saved[f]) parts.push(f + '=' + encodeURIComponent(saved[f])); });
    if (!parts.length) return;
    document.querySelectorAll('a[href*="play.google.com/store/apps/details"]').forEach(function (a) {
      if (a.href.indexOf('referrer=') !== -1) return;
      a.href += (a.href.indexOf('?') === -1 ? '?' : '&') + 'referrer=' + encodeURIComponent(parts.join('&'));
    });
  }

  // --- 2. Meta Pixel, only after consent ---------------------------------
  function loadPixel() {
    if (!META_PIXEL_ID || window.fbq) return;
    /* eslint-disable */
    !function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');
    /* eslint-enable */
    window.fbq('init', META_PIXEL_ID);
    window.fbq('track', 'PageView');
    document.addEventListener('click', function (event) {
      var link = event.target && event.target.closest ? event.target.closest('a') : null;
      if (!link) return;
      var href = link.getAttribute('href') || '';
      if (href.indexOf('/app/') === 0 || href.indexOf('play.google.com') !== -1) {
        window.fbq('track', 'Lead', { content_name: href.indexOf('play.google.com') !== -1 ? 'play_store' : 'web_app' });
      }
    }, true);
  }

  function consent() { return read(CONSENT_KEY); }

  function showBanner() {
    if (document.getElementById('sklConsent')) return;
    var bar = document.createElement('div');
    bar.id = 'sklConsent';
    bar.setAttribute('role', 'dialog');
    bar.setAttribute('aria-label', 'Cookies');
    bar.style.cssText = 'position:fixed;left:50%;bottom:16px;transform:translateX(-50%);z-index:1000;'
      + 'width:min(560px,calc(100vw - 24px));box-sizing:border-box;padding:14px 16px;border-radius:14px;'
      + 'background:#18181B;color:#FAFAFA;border:1px solid #3F3F46;box-shadow:0 12px 40px rgba(0,0,0,.45);'
      + 'font-family:inherit;font-size:14px;line-height:1.45;display:flex;gap:12px;align-items:center;flex-wrap:wrap;';
    bar.innerHTML = '<span style="flex:1;min-width:200px;color:#D4D4D8;">We use cookies to measure our ads and improve SkillLynk. '
      + '<a href="/privacy/" style="color:#34D399;">Privacy</a></span>'
      + '<button type="button" data-skl="no" style="padding:9px 14px;border-radius:10px;background:transparent;color:#FAFAFA;border:1px solid #3F3F46;font:inherit;font-weight:600;cursor:pointer;">No thanks</button>'
      + '<button type="button" data-skl="yes" style="padding:9px 14px;border-radius:10px;background:#34D399;color:#052E1C;border:0;font:inherit;font-weight:600;cursor:pointer;">Accept</button>';
    bar.addEventListener('click', function (event) {
      var choice = event.target && event.target.getAttribute && event.target.getAttribute('data-skl');
      if (!choice) return;
      write(CONSENT_KEY, { value: choice, at: Date.now() });
      bar.remove();
      if (choice === 'yes') loadPixel();
    });
    document.body.appendChild(bar);
  }

  function start() {
    tagPlayLinks();
    if (!META_PIXEL_ID) return;
    var saved = consent();
    if (saved && saved.value === 'yes') loadPixel();
    // Ask on the marketing site only; the web app at /app/ never covers its
    // screens with a banner, it just honours a choice made on the site.
    else if (!saved && window.location.pathname.indexOf('/app/') !== 0) showBanner();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start);
  else start();
})();
