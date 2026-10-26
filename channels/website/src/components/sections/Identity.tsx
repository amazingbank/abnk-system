import { Globe2, Layers } from 'lucide-react';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';

const IDENTITIES = [
  {
    no: '01',
    icon: Globe2,
    side: '对外',
    title: '一家银行',
    body: '一家面向全球用户的国际化数字银行。我们以中国市场为起点，以长期主义为方法，把银行应有的稳重、清晰与可信，带给每一个人。',
    tags: ['国际化', '数字原生', '大众关怀'],
  },
  {
    no: '02',
    icon: Layers,
    side: '对内',
    title: '一个范本',
    body: '一个生长在 ASDM 体系之上的活样本、真应用。它的目标不是演示，而是真实投产；它的开发流程、代码与设计全部公开，供每一家希望用 AI 重塑自身的企业参照。',
    tags: ['AI 优先', '可投产', '全流程开源'],
  },
];

export function Identity() {
  return (
    <section id="identity" className="relative bg-ivory py-24 md:py-40">
      <div className="page-x">
        <SectionHead
          index="01"
          label="Dual Identity"
          title={
            <>
              两种身份，
              <br className="hidden sm:block" />
              同一份承诺。
            </>
          }
          lead="ABNK 同时回答两个问题：一家银行应当如何服务世界？一家企业应当如何拥抱 AI？我们选择用同一个系统，同时给出两个答案。"
        />

        <div className="mt-20 grid grid-cols-1 border-t border-copper/30 md:mt-28 md:grid-cols-2">
          {IDENTITIES.map((item, i) => (
            <Reveal
              key={item.no}
              delay={i * 140}
              className={`group relative py-12 md:py-16 ${
                i === 0 ? 'md:pr-16' : 'border-t border-copper/30 md:border-l md:border-t-0 md:pl-16'
              }`}
            >
              <span className="absolute left-0 top-0 h-px w-0 bg-amber transition-all duration-700 group-hover:w-full" />
              <div className="flex items-start justify-between">
                <div className="eyebrow text-copper-600">
                  {item.no} — {item.side}
                </div>
                <item.icon
                  className="h-5 w-5 text-copper transition-transform duration-500 group-hover:rotate-12"
                  strokeWidth={1.25}
                />
              </div>
              <h3 className="mt-10 font-serif text-4xl font-semibold text-espresso md:text-5xl">{item.title}</h3>
              <p className="mt-6 max-w-md text-[15px] font-light text-espresso-500 md:text-base">{item.body}</p>
              <ul className="mt-10 flex flex-wrap gap-x-8 gap-y-3">
                {item.tags.map((t) => (
                  <li key={t} className="flex items-center gap-2 text-[13px] tracking-[0.06em] text-espresso-600">
                    <span className="h-1 w-1 bg-copper" />
                    {t}
                  </li>
                ))}
              </ul>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}
