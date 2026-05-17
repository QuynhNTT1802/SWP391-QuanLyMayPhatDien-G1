
const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light')
    root.setAttribute('data-theme', storedTheme);
document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
});

// TOC scroll spy
const tocItems = document.querySelectorAll('.toc-item');
tocItems.forEach(item => {
    item.addEventListener('click', () => {
        const target = document.getElementById(item.dataset.toc);
        if (target)
            target.scrollIntoView({behavior: 'smooth', block: 'start'});
    });
});
const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
        if (e.isIntersecting) {
            tocItems.forEach(t => t.classList.remove('active'));
            const match = document.querySelector(`.toc-item[data-toc="${e.target.id}"]`);
            if (match)
                match.classList.add('active');
        }
    });
}, {rootMargin: '-100px 0px -60% 0px'});
document.querySelectorAll('.section').forEach(s => observer.observe(s));

// copy buttons
document.querySelectorAll('.copy-mini').forEach(btn => {
    btn.addEventListener('click', () => {
        navigator.clipboard?.writeText(btn.dataset.copy);
        const orig = btn.innerHTML;
        btn.innerHTML = '<svg viewBox="0 0 24 24" stroke="currentColor" fill="none" stroke-width="2.5"><path d="M20 6 9 17l-5-5"/></svg>';
        setTimeout(() => {
            btn.innerHTML = orig;
        }, 1200);
    });
});

// permission toggles
document.querySelectorAll('.toggle').forEach(toggle => {
    toggle.addEventListener('click', () => {
        toggle.classList.toggle('on');
        const item = toggle.closest('.perm-item') || toggle.closest('.pm-row');
        if (item)
            item.classList.toggle('disabled', !toggle.classList.contains('on'));
        // update module count
        const mod = toggle.closest('.perm-module');
        if (mod) {
            const total = mod.querySelectorAll('.pm-row .toggle').length;
            const active = mod.querySelectorAll('.pm-row .toggle.on').length;
            const countEl = mod.querySelector('.pm-count');
            if (countEl)
                countEl.textContent = active + '/' + total;
        }
    });
});