import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';
import { useHome } from '@/i18n';

export function Principles() {
  const t = useHome().principles;

  return (
    <section id="principles" className="relative bg-ivory py-24 md:py-40">
      <div className="page-x">
        <SectionHead index={t.index} label={t.label} title={t.title} />

        <Reveal delay={120} className="mt-16 md:mt-24">
          <blockquote className="relative border-l-2 border-copper pl-6 md:ml-[25%] md:pl-10">
            <p className="font-serif text-2xl font-normal text-espresso sm:text-3xl lg:text-[40px] lg:leading-[1.35]">
              “{t.quote.line1}
              <br className="hidden lg:block" />
              {t.quote.line2}”
            </p>
            <footer className="eyebrow mt-8 text-copper-600">{t.quoteSource}</footer>
          </blockquote>
        </Reveal>

        <div className="mt-20 md:mt-28">
          {t.items.map((p, i) => (
            <Reveal key={p.no} delay={i * 80}>
              <div className="group grid grid-cols-12 items-baseline gap-x-6 gap-y-3 border-t border-copper/30 py-8 transition-colors duration-500 hover:bg-ivory-200/70 md:py-10">
                <span className="col-span-2 font-mono text-[11px] tracking-eyebrow text-copper-600 md:col-span-3">{p.no}</span>
                <div className="col-span-10 md:col-span-3">
                  <h3 className="text-3xl font-semibold text-espresso transition-transform duration-500 group-hover:translate-x-2 md:text-4xl">
                    {p.name}
                  </h3>
                  <span className="mt-2 block font-mono text-[10px] uppercase tracking-[0.2em] text-taupe-500">{p.note}</span>
                </div>
                <p className="col-span-10 col-start-3 text-[15px] font-light text-espresso-500 md:col-span-6 md:col-start-auto md:text-base">
                  {p.body}
                </p>
              </div>
            </Reveal>
          ))}
          <div className="h-px bg-copper/30" />
        </div>
      </div>
    </section>
  );
}
