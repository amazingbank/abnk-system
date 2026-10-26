import { Globe2, Layers } from 'lucide-react';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';
import { useHome } from '@/i18n';

// 图标属于展示结构，与语言包中的 items 按下标配对。
const ICONS = [Globe2, Layers];

export function Identity() {
  const t = useHome().identity;

  return (
    <section id="identity" className="relative bg-ivory py-24 md:py-40">
      <div className="page-x">
        <SectionHead
          index={t.index}
          label={t.label}
          title={
            <>
              {t.title.line1}
              <br className="hidden sm:block" />
              {t.title.line2}
            </>
          }
          lead={t.lead}
        />

        <div className="mt-20 grid grid-cols-1 border-t border-copper/30 md:mt-28 md:grid-cols-2">
          {t.items.map((item, i) => {
            const Icon = ICONS[i];
            return (
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
                  {Icon && (
                    <Icon className="h-5 w-5 text-copper transition-transform duration-500 group-hover:rotate-12" strokeWidth={1.25} />
                  )}
                </div>
                <h3 className="mt-10 font-serif text-4xl font-semibold text-espresso md:text-5xl">{item.title}</h3>
                <p className="mt-6 max-w-md text-[15px] font-light text-espresso-500 md:text-base">{item.body}</p>
                <ul className="mt-10 flex flex-wrap gap-x-8 gap-y-3">
                  {item.tags.map((tag) => (
                    <li key={tag} className="flex items-center gap-2 text-[13px] tracking-[0.06em] text-espresso-600">
                      <span className="h-1 w-1 bg-copper" />
                      {tag}
                    </li>
                  ))}
                </ul>
              </Reveal>
            );
          })}
        </div>
      </div>
    </section>
  );
}
