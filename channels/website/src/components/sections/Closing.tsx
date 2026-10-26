import { ArrowRight, ArrowUpRight } from 'lucide-react';
import { Logo, NAV_ITEMS } from '@/components/Nav';
import { NetworkCanvas } from '@/components/NetworkCanvas';
import { Reveal } from '@/components/Reveal';

export function Closing() {
  return (
    <section id="contact" className="relative overflow-hidden bg-char text-warmwhite">
      <div className="absolute inset-0 opacity-60 [mask-image:radial-gradient(ellipse_at_center,black,transparent_70%)]">
        <NetworkCanvas />
      </div>
      <div className="page-x relative py-28 text-center md:py-44">
        <Reveal>
          <div className="eyebrow flex items-center justify-center gap-3 text-amber">
            <span className="h-px w-8 bg-amber/60" />
            The Beginning
            <span className="h-px w-8 bg-amber/60" />
          </div>
        </Reveal>
        <Reveal delay={100}>
          <h2 className="mx-auto mt-10 max-w-4xl font-serif text-4xl font-semibold tracking-tight sm:text-6xl lg:text-[80px]">
            这是一家银行的开始，
            <br />
            <span className="text-amber">也是一种方法的证明。</span>
          </h2>
        </Reveal>
        <Reveal delay={200}>
          <p className="mx-auto mt-10 max-w-xl text-base font-light text-taupe-200 sm:text-lg">
            无论你关心一家值得信赖的新银行，还是关心 AI 如何真正改变一家企业——欢迎与我们一同见证。
          </p>
        </Reveal>
        <Reveal delay={300} className="mt-12 flex flex-col items-center justify-center gap-4 sm:flex-row">
          <a
            href="https://asdm.ai"
            target="_blank"
            rel="noopener noreferrer"
            className="group inline-flex w-full items-center justify-between gap-6 bg-amber px-7 py-4 text-[13px] font-semibold tracking-[0.12em] text-char transition-colors duration-300 hover:bg-amber-300 sm:w-auto"
          >
            探索 ASDM 体系
            <ArrowUpRight className="h-4 w-4 transition-transform duration-300 group-hover:-translate-y-0.5 group-hover:translate-x-0.5" />
          </a>
          <a
            href="#identity"
            className="group inline-flex w-full items-center justify-between gap-6 border border-taupe-500 px-7 py-4 text-[13px] tracking-[0.12em] text-warmwhite transition-colors duration-300 hover:border-amber hover:text-amber sm:w-auto"
          >
            重新阅读主张
            <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-1" />
          </a>
        </Reveal>
      </div>
    </section>
  );
}

export function Footer() {
  return (
    <footer className="border-t border-copper/20 bg-char-900 text-warmwhite">
      <div className="page-x grid grid-cols-12 gap-y-12 py-16">
        <div className="col-span-12 md:col-span-5">
          <Logo />
          <p className="mt-6 max-w-sm text-sm font-light text-taupe-300">
            一家服务全球用户的国际化数字银行，也是一个生长在 ASDM 体系之上的开源范本。
          </p>
        </div>
        <nav className="col-span-6 md:col-span-3 md:col-start-7" aria-label="页脚导航">
          <div className="eyebrow text-amber">页面导航</div>
          <ul className="mt-6 space-y-3">
            {NAV_ITEMS.map((item) => (
              <li key={item.id}>
                <a href={`#${item.id}`} className="text-sm text-taupe-200 transition-colors hover:text-amber">
                  {item.label}
                </a>
              </li>
            ))}
          </ul>
        </nav>
        <div className="col-span-6 md:col-span-3">
          <div className="eyebrow text-amber">体系</div>
          <ul className="mt-6 space-y-3">
            <li>
              <a
                href="https://asdm.ai"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1.5 text-sm text-taupe-200 transition-colors hover:text-amber"
              >
                asdm.ai <ArrowUpRight className="h-3.5 w-3.5" />
              </a>
            </li>
            <li className="text-sm text-taupe-400">开源仓库 · 即将公开</li>
          </ul>
        </div>
      </div>
      <div className="border-t border-copper/15">
        <div className="page-x flex flex-col justify-between gap-3 py-6 font-mono text-[11px] tracking-[0.12em] text-taupe-400 sm:flex-row">
          <span>© {new Date().getFullYear()} Amazing Bank（ABNK）</span>
          <span>Built on ASDM · Open by Default</span>
        </div>
      </div>
    </footer>
  );
}
