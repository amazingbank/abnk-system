import { useEffect, useState } from 'react';
import { ArrowUpRight, Menu, X } from 'lucide-react';
import { LanguageToggle } from '@/components/LanguageToggle';
import { useCommon } from '@/i18n';

// ASDM 官方 logo 图形（来源 asdm-ai-2026 public/images/logo——旋转矩形叠层）
function AsdmMark({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 128 128" aria-hidden className={className} fill="none" stroke="currentColor">
      <rect width="82" height="82" x="23" y="23" strokeWidth="5.5" opacity=".95" rx="13" transform="rotate(-24 64 64)" />
      <rect width="72" height="72" x="28" y="28" strokeWidth="4.4" opacity=".88" rx="11.5" transform="rotate(-18 64 64)" />
      <rect width="62" height="62" x="33" y="33" strokeWidth="3.4" opacity=".8" rx="10.5" transform="rotate(-12 64 64)" />
      <rect width="54" height="54" x="37" y="37" strokeWidth="2.6" opacity=".72" rx="9.5" transform="rotate(-6 64 64)" />
      <rect width="46" height="46" x="41" y="41" strokeWidth="1.9" opacity=".64" rx="8.5" />
      <rect width="39" height="39" x="44.5" y="44.5" strokeWidth="1.35" opacity=".55" rx="7.5" transform="rotate(6 64 64)" />
      <rect width="33" height="33" x="47.5" y="47.5" strokeWidth=".95" opacity=".46" rx="6.5" transform="rotate(12 64 64)" />
      <rect width="27" height="27" x="50.5" y="50.5" strokeWidth=".65" opacity=".37" rx="5.5" transform="rotate(19 64 64)" />
      <rect width="22" height="22" x="53.5" y="53.5" strokeWidth=".42" opacity=".27" rx="5" transform="rotate(27 64 64)" />
      <rect width="17" height="17" x="55.5" y="55.5" strokeWidth=".26" opacity=".18" rx="4" transform="rotate(36 64 64)" />
    </svg>
  );
}

export function Logo({ className = '' }: { className?: string }) {
  const common = useCommon();
  return (
    <a href="#top" className={`group flex items-center gap-3.5 ${className}`} aria-label={common.brand.homeLabel}>
      <AsdmMark className="h-9 w-9 shrink-0 text-amber" />
      <span className="flex flex-col leading-none">
        <span className="text-[17px] font-semibold tracking-[0.08em] text-warmwhite">ABNK</span>
        <span className="mt-1.5 font-mono text-[10px] uppercase tracking-[0.28em] text-taupe-300">Amazing Bank</span>
      </span>
    </a>
  );
}

export function Nav() {
  const common = useCommon();
  const navItems = common.nav.primary;
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState('');

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 24);
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    const els = navItems.map((i) => document.getElementById(i.id)).filter(Boolean) as HTMLElement[];
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) setActive(e.target.id);
        });
      },
      { rootMargin: '-45% 0px -50% 0px' },
    );
    els.forEach((el) => io.observe(el));
    return () => io.disconnect();
  }, [navItems]);

  useEffect(() => {
    document.body.style.overflow = open ? 'hidden' : '';
  }, [open]);

  return (
    <header
      className={`fixed inset-x-0 top-0 z-50 transition-all duration-500 ${
        scrolled || open ? 'border-b border-copper/20 bg-char-900/95 backdrop-blur-md' : 'border-b border-transparent bg-transparent'
      }`}
    >
      <div className="page-x flex h-[72px] items-center justify-between">
        <Logo />

        <nav className="hidden items-center gap-10 lg:flex" aria-label={common.nav.mainAria}>
          {navItems.map((item) => (
            <a
              key={item.id}
              href={`#${item.id}`}
              className={`group relative py-2 text-[13px] tracking-[0.06em] transition-colors duration-300 ${
                active === item.id ? 'text-amber' : 'text-taupe-200 hover:text-warmwhite'
              }`}
            >
              {item.label}
              <span
                className={`absolute -bottom-0.5 left-0 h-px bg-amber transition-all duration-500 ${
                  active === item.id ? 'w-full' : 'w-0 group-hover:w-full'
                }`}
              />
            </a>
          ))}
        </nav>

        <div className="flex items-center gap-4">
          <a
            href="https://asdm.ai"
            target="_blank"
            rel="noopener noreferrer"
            className="group hidden h-10 items-center gap-2 border border-copper/60 px-4 text-[12px] tracking-[0.12em] text-warmwhite transition-all duration-300 hover:border-amber hover:bg-amber hover:text-char md:flex"
          >
            {common.nav.knowAsdm}
            <ArrowUpRight className="h-3.5 w-3.5 transition-transform duration-300 group-hover:-translate-y-0.5 group-hover:translate-x-0.5" />
          </a>
          <LanguageToggle />
          <button
            type="button"
            onClick={() => setOpen((v) => !v)}
            className="flex h-10 w-10 items-center justify-center border border-copper/40 text-warmwhite lg:hidden"
            aria-label={open ? common.nav.menu.close : common.nav.menu.open}
            aria-expanded={open}
          >
            {open ? <X className="h-4 w-4" /> : <Menu className="h-4 w-4" />}
          </button>
        </div>
      </div>

      <div
        className={`overflow-hidden bg-char-900 transition-[max-height] duration-500 lg:hidden ${
          open ? 'max-h-[100vh]' : 'max-h-0'
        }`}
      >
        <nav className="page-x flex min-h-[calc(100vh-72px)] flex-col pb-10 pt-4" aria-label={common.nav.mobileAria}>
          {navItems.map((item, i) => (
            <a
              key={item.id}
              href={`#${item.id}`}
              onClick={() => setOpen(false)}
              className="flex items-baseline gap-5 border-b border-copper/15 py-6 text-2xl font-light text-warmwhite"
            >
              <span className="font-mono text-[11px] text-amber">0{i + 1}</span>
              {item.label}
            </a>
          ))}
          <a
            href="https://asdm.ai"
            target="_blank"
            rel="noopener noreferrer"
            className="mt-auto flex items-center justify-between border border-copper/60 px-5 py-4 text-sm tracking-[0.12em] text-warmwhite"
          >
            {common.nav.knowAsdm} <ArrowUpRight className="h-4 w-4 text-amber" />
          </a>
        </nav>
      </div>
    </header>
  );
}
