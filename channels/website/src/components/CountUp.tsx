import { useEffect, useState } from 'react';
import { useInView } from '@/components/Reveal';

type CountUpProps = {
  to: number;
  duration?: number;
  pad?: number;
  suffix?: string;
  className?: string;
};

export function CountUp({ to, duration = 1600, pad = 0, suffix = '', className = '' }: CountUpProps) {
  const { ref, inView } = useInView<HTMLSpanElement>(0.4);
  const [value, setValue] = useState(0);

  useEffect(() => {
    if (!inView) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setValue(to);
      return;
    }
    let raf = 0;
    const start = performance.now();
    const tick = (now: number) => {
      const t = Math.min(1, (now - start) / duration);
      const eased = 1 - Math.pow(1 - t, 4);
      setValue(Math.round(to * eased));
      if (t < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
  }, [inView, to, duration]);

  return (
    <span ref={ref} className={`tabular-nums ${className}`}>
      {String(value).padStart(pad, '0')}
      {suffix}
    </span>
  );
}
