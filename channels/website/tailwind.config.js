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
        sans: ['Inter', '"Noto Sans SC"', 'system-ui', 'sans-serif'],
        serif: ['"Noto Serif SC"', 'Georgia', 'serif'],
        mono: ['"IBM Plex Mono"', 'ui-monospace', 'monospace'],
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
