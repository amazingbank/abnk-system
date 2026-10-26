import { Nav } from '@/components/Nav';
import { Asdm } from '@/components/sections/Asdm';
import { Closing, Footer } from '@/components/sections/Closing';
import { GlobalPath } from '@/components/sections/GlobalPath';
import { Hero } from '@/components/sections/Hero';
import { Identity } from '@/components/sections/Identity';
import { OpenSource } from '@/components/sections/OpenSource';
import { Principles } from '@/components/sections/Principles';

function App() {
  return (
    <>
      <Nav />
      <main>
        <Hero />
        <Identity />
        <GlobalPath />
        <Asdm />
        <OpenSource />
        <Principles />
        <Closing />
      </main>
      <Footer />
    </>
  );
}

export default App;
