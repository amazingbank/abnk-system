import { Code2, GitBranch, PenTool } from 'lucide-react';
import { CountUp } from '@/components/CountUp';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';
import { useHome } from '@/i18n';

// 数字统计的数值配置（文案见 locales/*/home.json → openSource.stats，与下标一一对应）。
const STATS = [
  { to: 100, suffix: '%', pad: 0 },
  { to: 3, suffix: '', pad: 2 },
  { to: 4, suffix: '', pad: 2 },
  { to: 1, suffix: '', pad: 2 },
];

const ICONS = [GitBranch, Code2, PenTool];

export function OpenSource() {
  const t = useHome().openSource;

  return (
    <section id="open" className="relative overflow-hidden bg-char py-24 text-warmwhite md:py-40">
      <div
        className="pointer-events-none absolute -left-40 bottom-0 h-[600px] w-[600px] rounded-full blur-3xl"
        style={{ background: 'radial-gradient(circle, rgba(176,138,79,0.14), rgba(38,32,26,0) 65%)' }}
      />
      <div className="page-x relative">
        <SectionHead
          tone="dark"
          index={t.index}
          label={t.label}
          title={
            <>
              {t.title.line1}
              <br className="hidden sm:block" />
              <span className="text-amber">{t.title.line2}</span>
            </>
          }
          lead={t.lead}
        />

        <div className="mt-20 grid grid-cols-2 gap-px border-y border-copper/25 bg-copper/25 md:mt-28 lg:grid-cols-4">
          {STATS.map((s, i) => (
            <Reveal key={s.to} delay={i * 100} className="bg-char p-6 md:p-10">
              <div className="font-serif text-5xl font-semibold text-amber md:text-7xl">
                <CountUp to={s.to} pad={s.pad} suffix={s.suffix} />
              </div>
              <div className="mt-4 text-[13px] tracking-[0.08em] text-taupe-200">{t.stats[i]}</div>
            </Reveal>
          ))}
        </div>

        <div className="mt-24 grid grid-cols-1 gap-12 md:grid-cols-3 md:gap-10">
          {t.assets.map((a, i) => {
            const Icon = ICONS[i];
            return (
              <Reveal key={a.name} delay={i * 120} className="group">
                <div className="hairline" />
                <div className="mt-8 flex items-center justify-between">
                  <span className="font-mono text-[10px] uppercase tracking-[0.22em] text-taupe-400">{a.note}</span>
                  {Icon && <Icon className="h-5 w-5 text-copper-400 transition-colors duration-300 group-hover:text-amber" strokeWidth={1.25} />}
                </div>
                <h3 className="mt-6 text-3xl font-semibold text-warmwhite">{a.name}</h3>
                <p className="mt-4 max-w-sm text-[15px] font-light text-taupe-300">{a.body}</p>
              </Reveal>
            );
          })}
        </div>
      </div>
    </section>
  );
}
