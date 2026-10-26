import { ArrowDown, ArrowRight } from 'lucide-react';
import { NetworkCanvas } from '@/components/NetworkCanvas';

const META = [
  { k: '首批落地', v: '中国市场' },
  { k: '构建于', v: 'ASDM 体系' },
  { k: '全部开放', v: '流程 · 代码 · 设计' },
];

export function Hero() {
  return (
    <section id="top" className="relative flex min-h-[100svh] flex-col overflow-hidden bg-char text-warmwhite">
      <div className="grid-bg-dark absolute inset-0" />
      <div
        className="pointer-events-none absolute -right-40 top-1/4 h-[720px] w-[720px] rounded-full opacity-60 blur-3xl"
        style={{ background: 'radial-gradient(circle, rgba(217,165,92,0.16), rgba(38,32,26,0) 65%)' }}
      />
      <div className="absolute inset-0 [mask-image:linear-gradient(to_bottom,transparent,black_20%,black_70%,transparent)]">
        <NetworkCanvas />
      </div>

      <div className="page-x relative flex flex-1 flex-col justify-center pb-16 pt-32">
        <div className="hero-in eyebrow flex items-center gap-3 text-amber" style={{ animationDelay: '100ms' }}>
          <span className="h-px w-10 bg-amber/70" />
          Amazing Bank · ABNK
        </div>

        <h1 className="mt-10 max-w-5xl font-serif text-[48px] font-semibold tracking-tight sm:text-7xl lg:text-[112px]">
          <span className="hero-in block" style={{ animationDelay: '200ms' }}>
            一家银行。
          </span>
          <span className="hero-in block text-amber" style={{ animationDelay: '380ms' }}>
            也是一个范本。
          </span>
        </h1>

        <p
          className="hero-in mt-10 max-w-xl text-base font-light text-taupe-200 sm:text-lg"
          style={{ animationDelay: '560ms' }}
        >
          对外，我们是服务全球用户的国际化数字银行；对内，我们是生长在 ASDM 体系之上、从第一行代码起就面向投产的开源范例。
        </p>

        <div className="hero-in mt-12 flex flex-col gap-4 sm:flex-row" style={{ animationDelay: '720ms' }}>
          <a
            href="#identity"
            className="group inline-flex items-center justify-between gap-6 bg-amber px-7 py-4 text-[13px] font-semibold tracking-[0.12em] text-char transition-colors duration-300 hover:bg-amber-300"
          >
            阅读我们的主张
            <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-1" />
          </a>
          <a
            href="#asdm"
            className="group inline-flex items-center justify-between gap-6 border border-taupe-500 px-7 py-4 text-[13px] tracking-[0.12em] text-warmwhite transition-colors duration-300 hover:border-amber hover:text-amber"
          >
            ASDM 如何驱动 ABNK
            <ArrowRight className="h-4 w-4 transition-transform duration-300 group-hover:translate-x-1" />
          </a>
        </div>
      </div>

      <div className="relative border-t border-copper/20">
        <div className="page-x grid grid-cols-2 md:grid-cols-4">
          {META.map((m, i) => (
            <div
              key={m.k}
              className={`py-6 md:py-8 ${i > 0 ? 'md:border-l md:border-copper/20 md:pl-8' : ''} ${i === 2 ? 'col-span-2 md:col-span-1' : ''}`}
            >
              <div className="eyebrow text-taupe-400">{m.k}</div>
              <div className="mt-2 text-[15px] text-warmwhite">{m.v}</div>
            </div>
          ))}
          <a
            href="#identity"
            className="group hidden items-center justify-end gap-3 py-8 text-taupe-300 transition-colors hover:text-amber md:flex md:border-l md:border-copper/20"
          >
            <span className="eyebrow">向下滚动</span>
            <ArrowDown className="h-4 w-4 animate-bounce" />
          </a>
        </div>
      </div>
    </section>
  );
}
