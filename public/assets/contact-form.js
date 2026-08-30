// No backend to submit to on a static site -- this builds a mailto: link
// from the form fields and opens the visitor's own email client, same
// pattern the old Flutter site's Contact Support dialog used. Honest about
// what it does (see the note under the form) rather than pretending a
// silent submit that isn't actually happening.
const contactForm = document.getElementById('contactForm');
if (contactForm) {
  contactForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const name = contactForm.name.value.trim();
    const email = contactForm.email.value.trim();
    const company = contactForm.company.value.trim();
    const message = contactForm.message.value.trim();

    const subject = `SkillLynk for Companies -- ${company || name}`;
    const body = [
      `Name: ${name}`,
      `Email: ${email}`,
      `Company: ${company}`,
      '',
      message,
    ].join('\n');

    const mailto = `mailto:skill.lynkk@gmail.com?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
    window.location.href = mailto;
  });
}
