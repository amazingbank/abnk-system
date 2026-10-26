import { Code2, GitBranch, PenTool } from 'lucide-react';
import { CountUp } from '@/components/CountUp';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';

const STATS = [
  { to: 100, suffix: '%', pad: 0, label: '开发过程公开' },
  { to: 3, suffix: '', pad: 2, label: '类开源资产' },
  { to: 4, suffix: '', pad: 2, label: '阶段全球路径' },
  { to: 1, suffix: '', pad: 2, label: '套统一方法体系' },
];

const ASSETS = [
  {
    icon: GitBranch,
    name: '开发流程',
    en: 'Process',
    body: '从意图到上线的每一个环节、每一次决策与复盘，都以可追溯的方式公开记录。',
  },
  {
    icon: Code2,
    name: '代码',
    en: 'Code',
    body: '面向真实投产标准编写的完整代码，开放给任何人阅读、审视与借鉴。',
  },
  {
    icon: PenTool,
    name: '设计',
    en: 'Design',
    body: '设计语言、交互规范与体验决策同步开放，让“好的体验”变得可复制。',
  },
];

export function OpenSource() {
  return (
    <section id="open" className="relative overflow-hidden bg-char py-24 text-warmwhite md:py-40">
      <div
        className="pointer-events-none absolute -left-40 bottom-0 h-[600px] w-[600px] rounded-full blur-3xl"
        style={{ background: 'radial-gradient(circle, rgba(176,138,79,0.14), rgba(38,32,26,0) 65%)' }}
      />
      <div className="page-x relative">
        <SectionHead
          tone="dark"
          index="04"
          label="Open by Default"
          title={
            <>
              全部公开，
              <br className="hidden sm:block" />
              <span className="text-amber">毫无保留。</span>
            </>
          }
          lead="企业引入 AI 进行全流程数字化改造，最缺的不是工具，而是一个真实、完整、可被检验的先例。ABNK 选择成为这个先例。"
        />

        <div className="mt-20 grid grid-cols-2 gap-px border-y border-copper/25 bg-copper/25 md:mt-28 lg:grid-cols-4">
          {STATS.map((s, i) => (
            <Reveal key={s.label} delay={i * 100} className="bg-char p-6 md:p-10">
              <div className="font-serif text-5xl font-semibold text-amber md:text-7xl">
                <CountUp to={s.to} pad={s.pad} suffix={s.suffix} />
              </div>
              <div className="mt-4 text-[13px] tracking-[0.08em] text-taupe-200">{s.label}</div>
            </Reveal>
          ))}
        </div>

        <div className="mt-24 grid grid-cols-1 gap-12 md:grid-cols-3 md:gap-10">
          {ASSETS.map((a, i) => (
            <Reveal key={a.name} delay={i * 120} className="group">
              <div className="hairline" />
              <div className="mt-8 flex items-center justify-between">
                <span className="font-mono text-[10px] uppercase tracking-[0.22em] text-taupe-400">{a.en}</span>
                <a.icon className="h-5 w-5 text-copper-400 transition-colors duration-300 group-hover:text-amber" strokeWidth={1.25} />
              </div>
              <h3 className="mt-6 text-3xl font-semibold text-warmwhite">{a.name}</h3>
              <p className="mt-4 max-w-sm text-[15px] font-light text-taupe-300">{a.body}</p>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}
