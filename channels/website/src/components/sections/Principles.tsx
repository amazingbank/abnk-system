import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';

const PRINCIPLES = [
  { no: '01', name: '稳重', en: 'Steadfast', body: '银行的第一责任是可信。我们以长期主义做每一个决定，不追逐喧嚣。' },
  { no: '02', name: '精确', en: 'Precise', body: '以工程的严谨对待每一处细节。可度量、可验证、可追溯。' },
  { no: '03', name: '开放', en: 'Open', body: '把过程与成果交给公众检验。透明，是最好的品质保证。' },
  { no: '04', name: '关怀', en: 'Caring', body: '技术的终点是人。让每一个人，都能被认真、平等地对待。' },
];

export function Principles() {
  return (
    <section id="principles" className="relative bg-ivory py-24 md:py-40">
      <div className="page-x">
        <SectionHead index="05" label="What We Believe" title="我们相信的事。" />

        <Reveal delay={120} className="mt-16 md:mt-24">
          <blockquote className="relative border-l-2 border-copper pl-6 md:ml-[25%] md:pl-10">
            <p className="font-serif text-2xl font-normal text-espresso sm:text-3xl lg:text-[40px] lg:leading-[1.35]">
              “银行级的稳重，与工程级的精确，<br className="hidden lg:block" />
              并不矛盾——它们本应来自同一种态度。”
            </p>
            <footer className="eyebrow mt-8 text-copper-600">ABNK 宣言</footer>
          </blockquote>
        </Reveal>

        <div className="mt-20 md:mt-28">
          {PRINCIPLES.map((p, i) => (
            <Reveal key={p.no} delay={i * 80}>
              <div className="group grid grid-cols-12 items-baseline gap-x-6 gap-y-3 border-t border-copper/30 py-8 transition-colors duration-500 hover:bg-ivory-200/70 md:py-10">
                <span className="col-span-2 font-mono text-[11px] tracking-eyebrow text-copper-600 md:col-span-3">{p.no}</span>
                <div className="col-span-10 md:col-span-3">
                  <h3 className="text-3xl font-semibold text-espresso transition-transform duration-500 group-hover:translate-x-2 md:text-4xl">
                    {p.name}
                  </h3>
                  <span className="mt-2 block font-mono text-[10px] uppercase tracking-[0.2em] text-taupe-500">{p.en}</span>
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
