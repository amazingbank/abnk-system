import type { ReactNode } from 'react';
import { Reveal } from '@/components/Reveal';

type SectionHeadProps = {
  index: string;
  label: string;
  title: ReactNode;
  lead?: ReactNode;
  tone?: 'light' | 'dark';
};

export function SectionHead({ index, label, title, lead, tone = 'light' }: SectionHeadProps) {
  const dark = tone === 'dark';
  return (
    <div className="grid grid-cols-12 gap-x-6 gap-y-8">
      <Reveal className="col-span-12 lg:col-span-3">
        <div className={`eyebrow flex items-center gap-3 ${dark ? 'text-amber' : 'text-copper-600'}`}>
          <span>{index}</span>
          <span className={`h-px w-8 ${dark ? 'bg-amber/60' : 'bg-copper/60'}`} />
          <span>{label}</span>
        </div>
      </Reveal>
      <div className="col-span-12 lg:col-span-9">
        <Reveal delay={80}>
          <h2
            className={`font-serif text-[34px] font-semibold tracking-tight sm:text-5xl lg:text-[64px] ${
              dark ? 'text-warmwhite' : 'text-espresso'
            }`}
          >
            {title}
          </h2>
        </Reveal>
        {lead && (
          <Reveal delay={160}>
            <p
              className={`mt-8 max-w-2xl text-base font-light sm:text-lg ${
                dark ? 'text-taupe-200' : 'text-espresso-500'
              }`}
            >
              {lead}
            </p>
          </Reveal>
        )}
      </div>
    </div>
  );
}
