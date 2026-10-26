import { useState } from 'react';
import { Reveal } from '@/components/Reveal';
import { SectionHead } from '@/components/SectionHead';

const STAGES = [
  { no: '01', name: '中国本土', en: 'China', body: '在最具数字活力的市场完成首批落地，打磨体系，验证范式。', x: 140, y: 260 },
  { no: '02', name: '东南亚', en: 'Southeast Asia', body: '走向多元文化与多语种的近邻市场，检验体系的适应力。', x: 450, y: 200 },
  { no: '03', name: '「一带一路」沿线', en: 'Belt & Road', body: '沿着连接世界的通道延伸，让同一套方法在更广的地域上生长。', x: 770, y: 150 },
  { no: '04', name: '发达国家市场', en: 'Developed Markets', body: '在最成熟、最严格的市场中，以同样的标准接受检验。', x: 1070, y: 90 },
];

const SATELLITES = STAGES.flatMap((s, si) =>
  Array.from({ length: 7 }, (_, k) => {
    const angle = (k / 7) * Math.PI * 2 + si;
    const dist = 38 + ((k * 37 + si * 13) % 46);
    return { hub: si, x: s.x + Math.cos(angle) * dist * 1.4, y: s.y + Math.sin(angle) * dist * 0.8 };
  }),
);

function RouteGraphic({ active }: { active: number }) {
  const path = STAGES.map((s, i) => `${i === 0 ? 'M' : 'L'} ${s.x} ${s.y}`).join(' ');
  return (
    <svg viewBox="0 0 1200 340" className="h-auto w-full" aria-hidden>
      <defs>
        <radialGradient id="hubGlow">
          <stop offset="0%" stopColor="#D9A55C" stopOpacity="0.45" />
          <stop offset="100%" stopColor="#D9A55C" stopOpacity="0" />
        </radialGradient>
      </defs>

      {SATELLITES.map((p, i) => (
        <line
          key={`l${i}`}
          x1={STAGES[p.hub].x}
          y1={STAGES[p.hub].y}
          x2={p.x}
          y2={p.y}
          stroke="#B08A4F"
          strokeWidth="0.6"
          strokeOpacity={p.hub <= active ? 0.55 : 0.15}
          className="transition-[stroke-opacity] duration-700"
        />
      ))}

      <path d={path} fill="none" stroke="#5A4C41" strokeWidth="1" />
      <path d={path} fill="none" stroke="#D9A55C" strokeWidth="1.2" className="dash-flow" />

      {SATELLITES.map((p, i) => (
        <circle
          key={`c${i}`}
          cx={p.x}
          cy={p.y}
          r="2"
          fill={p.hub <= active ? '#CDB085' : '#55493E'}
          className="transition-[fill] duration-700"
        />
      ))}

      {STAGES.map((s, i) => (
        <g key={s.no}>
          <circle cx={s.x} cy={s.y} r="44" fill="url(#hubGlow)" opacity={i === active ? 1 : 0.25} className="transition-opacity duration-700" />
          {i === active && <circle cx={s.x} cy={s.y} r="12" fill="none" stroke="#D9A55C" strokeWidth="1" className="pulse-soft" />}
          <circle cx={s.x} cy={s.y} r="6" fill={i <= active ? '#D9A55C' : '#26201A'} stroke="#D9A55C" strokeWidth="1.2" className="transition-[fill] duration-500" />
          <text x={s.x} y={s.y + 34} textAnchor="middle" className="fill-taupe-300 font-mono text-[11px] tracking-[0.2em]">
            {s.no}
          </text>
        </g>
      ))}
    </svg>
  );
}

export function GlobalPath() {
  const [active, setActive] = useState(0);

  return (
    <section id="global" className="relative overflow-hidden bg-char py-24 text-warmwhite md:py-40">
      <div className="grid-bg-dark absolute inset-0 opacity-70" />
      <div className="page-x relative">
        <SectionHead
          tone="dark"
          index="02"
          label="Global Path"
          title={
            <>
              从中国出发，
              <br className="hidden sm:block" />
              <span className="text-amber">走向世界。</span>
            </>
          }
          lead="ABNK 生而国际化。我们以清晰而耐心的节奏拓展版图，每一步都建立在上一步被验证的基础之上。"
        />

        <Reveal delay={120} className="mt-16 md:mt-24">
          <RouteGraphic active={active} />
        </Reveal>

        <div className="mt-10 grid grid-cols-1 gap-px border-y border-copper/25 bg-copper/25 sm:grid-cols-2 lg:grid-cols-4">
          {STAGES.map((s, i) => (
            <Reveal key={s.no} delay={i * 100} className="bg-char">
              <button
                type="button"
                onMouseEnter={() => setActive(i)}
                onFocus={() => setActive(i)}
                onClick={() => setActive(i)}
                className={`group relative h-full w-full px-6 py-8 text-left transition-colors duration-500 sm:px-8 lg:py-10 ${
                  i === active ? 'bg-char-700' : 'hover:bg-char-700/60'
                }`}
              >
                <span
                  className={`absolute left-0 top-0 h-px bg-amber transition-all duration-700 ${
                    i === active ? 'w-full' : 'w-0'
                  }`}
                />
                <div className="flex items-baseline justify-between">
                  <span className={`font-mono text-[11px] tracking-eyebrow ${i === active ? 'text-amber' : 'text-taupe-400'}`}>
                    阶段 {s.no}
                  </span>
                  <span className="font-mono text-[10px] uppercase tracking-[0.18em] text-taupe-500">{s.en}</span>
                </div>
                <h3 className={`mt-6 text-2xl font-semibold transition-colors duration-500 ${i === active ? 'text-warmwhite' : 'text-taupe-200'}`}>
                  {s.name}
                </h3>
                <p className="mt-4 text-sm font-light text-taupe-300">{s.body}</p>
              </button>
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}
