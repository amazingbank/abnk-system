import { useState } from 'react';
import { ArrowUpRight } from 'lucide-react';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';
import { useHome } from '@/i18n';

// 知识图谱节点布局（纯图形数据，与语言无关）。
const GRAPH = [
  { x: 200, y: 60, p: 0 }, { x: 110, y: 120, p: 0 }, { x: 280, y: 130, p: 0 },
  { x: 330, y: 220, p: 1 }, { x: 400, y: 150, p: 1 }, { x: 430, y: 270, p: 1 },
  { x: 300, y: 330, p: 2 }, { x: 200, y: 400, p: 2 }, { x: 330, y: 430, p: 2 },
  { x: 110, y: 330, p: 3 }, { x: 60, y: 230, p: 3 }, { x: 150, y: 250, p: 3 },
];
const CORE = { x: 240, y: 250 };
const EDGES: [number, number][] = [
  [0, 1], [0, 2], [2, 4], [4, 3], [3, 5], [5, 8], [6, 8], [6, 7], [7, 9], [9, 10], [10, 1], [11, 9], [2, 3], [6, 3], [11, 1],
];

function KnowledgeGraph({ active }: { active: number }) {
  return (
    <svg viewBox="0 0 480 480" className="h-auto w-full max-w-[520px]" aria-hidden>
      <circle cx={CORE.x} cy={CORE.y} r="200" fill="none" stroke="#B08A4F" strokeOpacity="0.18" />
      <circle cx={CORE.x} cy={CORE.y} r="120" fill="none" stroke="#B08A4F" strokeOpacity="0.25" strokeDasharray="2 6" />
      {EDGES.map(([a, b], i) => {
        const on = GRAPH[a].p === active || GRAPH[b].p === active;
        return (
          <line
            key={i}
            x1={GRAPH[a].x}
            y1={GRAPH[a].y}
            x2={GRAPH[b].x}
            y2={GRAPH[b].y}
            stroke={on ? '#B08A4F' : '#C4B7A6'}
            strokeWidth={on ? 1.2 : 0.8}
            className="transition-all duration-500"
          />
        );
      })}
      {GRAPH.map((n, i) => (
        <line
          key={`c${i}`}
          x1={CORE.x}
          y1={CORE.y}
          x2={n.x}
          y2={n.y}
          stroke="#D9A55C"
          strokeOpacity={n.p === active ? 0.9 : 0.12}
          strokeWidth="0.8"
          className={`transition-all duration-500 ${n.p === active ? 'dash-flow' : ''}`}
        />
      ))}
      {GRAPH.map((n, i) => (
        <rect
          key={`n${i}`}
          x={n.x - 5}
          y={n.y - 5}
          width="10"
          height="10"
          fill={n.p === active ? '#B08A4F' : '#FAF7F2'}
          stroke={n.p === active ? '#8F6E3D' : '#A89A88'}
          className="transition-all duration-500"
        />
      ))}
      <circle cx={CORE.x} cy={CORE.y} r="34" fill="#26201A" />
      <circle cx={CORE.x} cy={CORE.y} r="40" fill="none" stroke="#D9A55C" strokeWidth="1" className="pulse-soft" />
      <text x={CORE.x} y={CORE.y + 4} textAnchor="middle" className="fill-amber font-mono text-[12px] tracking-[0.18em]">
        ASDM
      </text>
    </svg>
  );
}

export function Asdm() {
  const [active, setActive] = useState(0);
  const t = useHome().asdm;

  return (
    <section id="asdm" className="relative bg-ivory py-24 md:py-40">
      <div className="grid-bg-light absolute inset-0 opacity-60 [mask-image:linear-gradient(to_bottom,black,transparent)]" />
      <div className="page-x relative">
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

        <div className="mt-20 grid grid-cols-12 items-center gap-y-16 md:mt-28 lg:gap-x-16">
          <Reveal className="col-span-12 flex justify-center lg:col-span-5">
            <KnowledgeGraph active={active} />
          </Reveal>

          <div className="col-span-12 lg:col-span-7">
            <ol className="border-t border-copper/30">
              {t.phases.map((p, i) => (
                <Reveal as="li" key={p.no} delay={i * 90} className="border-b border-copper/30">
                  <button
                    type="button"
                    onMouseEnter={() => setActive(i)}
                    onFocus={() => setActive(i)}
                    onClick={() => setActive(i)}
                    className="group grid w-full grid-cols-12 items-baseline gap-4 py-7 text-left md:py-8"
                  >
                    <span className={`col-span-2 font-mono text-[11px] tracking-eyebrow transition-colors md:col-span-1 ${i === active ? 'text-copper-600' : 'text-taupe-400'}`}>
                      {p.no}
                    </span>
                    <span className="col-span-10 md:col-span-3">
                      <span className={`block text-2xl font-semibold transition-colors duration-300 ${i === active ? 'text-espresso' : 'text-taupe-500 group-hover:text-espresso-600'}`}>
                        {p.name}
                      </span>
                      <span className="mt-1 block font-mono text-[10px] uppercase tracking-[0.2em] text-taupe-400">{p.note}</span>
                    </span>
                    <span
                      className={`col-span-10 col-start-3 text-[15px] font-light transition-all duration-500 md:col-span-8 md:col-start-auto ${
                        i === active ? 'text-espresso-500 opacity-100' : 'text-taupe-500 opacity-70'
                      }`}
                    >
                      {p.body}
                    </span>
                  </button>
                </Reveal>
              ))}
            </ol>

            <Reveal delay={200} className="mt-10">
              <a
                href="https://asdm.ai"
                target="_blank"
                rel="noopener noreferrer"
                className="group inline-flex items-center gap-3 text-[13px] font-semibold tracking-[0.12em] text-copper-600 transition-colors hover:text-espresso"
              >
                <span className="border-b border-copper/50 pb-1 transition-colors group-hover:border-espresso">{t.visitLink}</span>
                <ArrowUpRight className="h-4 w-4 transition-transform duration-300 group-hover:-translate-y-0.5 group-hover:translate-x-0.5" />
              </a>
            </Reveal>
          </div>
        </div>
      </div>
    </section>
  );
}
