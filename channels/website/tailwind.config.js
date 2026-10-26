/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        ivory: { DEFAULT: '#FAF7F2', 50: '#FDFBF8', 100: '#FAF7F2', 200: '#F2ECE2', 300: '#E8DFD1' },
        char: { DEFAULT: '#26201A', 700: '#2F2820', 800: '#26201A', 900: '#1C1813', 950: '#15110D' },
        espresso: { DEFAULT: '#3D322A', 400: '#6B5D51', 500: '#5A4C41', 600: '#4A3E35', 700: '#3D322A' },
        warmwhite: '#F5EFE6',
        copper: { DEFAULT: '#B08A4F', 300: '#CDB085', 400: '#C09D68', 500: '#B08A4F', 600: '#8F6E3D', 700: '#6E542F' },
        amber: { DEFAULT: '#D9A55C', 300: '#EAC791', 400: '#E1B673', 500: '#D9A55C', 600: '#BE8A42' },
        taupe: { 100: '#EDE6DC', 200: '#DCD2C4', 300: '#C4B7A6', 400: '#A89A88', 500: '#8C7E6D', 600: '#706355', 700: '#55493E' },
        sage: { 300: '#A9B79A', 500: '#7A8C68', 700: '#55654A' },
        ochre: { 300: '#E6C27A', 500: '#C99A3B', 700: '#8F6B22' },
        brick: { 300: '#D49A88', 500: '#B5604A', 700: '#844332' },
      },
      fontFamily: {
        // 自托管 @fontsource-variable（无外部 CDN），中英文靠字体栈逐字符回退，无需 JS 切换。
        // Latin: Oxanium · CJK: Noto Sans SC · Mono: JetBrains Mono —— 与 asdm-ai-2026 完全一致。
        // Display serif: Noto Serif SC —— ABNK 品牌衬线大标题（方案 A）。
        // 若决策切换为「与 asdm 完全一致（方案 B）」：删除 serif 行，全站 font-serif 改 font-sans。
        sans: ['"Oxanium Variable"', '"Noto Sans SC Variable"', 'ui-sans-serif', 'system-ui', 'sans-serif'],
        serif: ['"Noto Serif SC Variable"', 'Georgia', 'serif'],
        mono: ['"JetBrains Mono Variable"', '"Noto Sans SC Variable"', 'ui-monospace', 'monospace'],
      },
      letterSpacing: {
        eyebrow: '0.22em',
      },
      maxWidth: {
        page: '1360px',
      },
    },
  },
  plugins: [],
};
