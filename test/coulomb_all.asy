import feynmanmf;

CoulombIntegral Vabcd = CoulombIntegral(
  "abcd",
  angles=new real[]{110,70,110,70}
);
CoulombIntegral Vabci = CoulombIntegral(
  "abci",
  angles=new real[]{110,70,110,110}
);
CoulombIntegral Vabic = CoulombIntegral(
  "abic",
  angles=new real[]{110,70,70,70}
);
CoulombIntegral Vaibc = CoulombIntegral(
  "aibc",
  angles=new real[]{110,110,110,70}
);
CoulombIntegral Viabc = CoulombIntegral(
  "iabc",
  angles=new real[]{70,70,110,70}
);
CoulombIntegral Vabij = CoulombIntegral(
  "abij",
  angles=new real[]{110,110,70,70}
);
CoulombIntegral Vaibj = CoulombIntegral(
  "aibj",
  angles=new real[]{110,70,110,70}
);
CoulombIntegral Viabj = CoulombIntegral(
  "iabj",
  angles=new real[]{70,70,110,110}
);
CoulombIntegral Vaijb = CoulombIntegral(
  "aijb",
  angles=new real[]{110,110,70,70}
);
CoulombIntegral Viajb = CoulombIntegral(
  "iajb",
  angles=new real[]{110,70,110,70}
);
CoulombIntegral Vijab = CoulombIntegral(
  "ijab",
  angles=new real[]{110,110,70,70}
);
CoulombIntegral Vaijk = CoulombIntegral(
  "aijk",
  angles=new real[]{70,70,110,70}
);
CoulombIntegral Viajk = CoulombIntegral(
  "iajk",
  angles=new real[]{110,70,110,110}
);
CoulombIntegral Vijak = CoulombIntegral(
  "ijak",
  angles=new real[]{70,70,110,70}
);
CoulombIntegral Vijka = CoulombIntegral(
  "ijka",
  angles=new real[]{110,70,110,110}
);
CoulombIntegral Vijkl = CoulombIntegral(
  "ijkl",
  angles=new real[]{110,70,110,70}
);


CoulombIntegral Integrals[] = {
  Vabcd, Vabci, Vabic, Vaibc, Viabc, Vabij, Vaibj, Viabj,
  Vaijb, Viajb, Vijab, Vaijk, Viajk, Vijak, Vijka, Vijkl
};

real xsep = 200;
real ysep = -250;

for ( int i = 0; i < Integrals.length; i+=1 ) {
  pair S = i<8 ? (i * xsep, 0) : ((i-8) * xsep, ysep);
  draw(shift(S) * Integrals[i], true);
  label(
    Integrals[i].name, shift(S + (0,20)) * (
      0.5*Integrals[i].r1 + 0.5*Integrals[i].r2
    )
  );
}


