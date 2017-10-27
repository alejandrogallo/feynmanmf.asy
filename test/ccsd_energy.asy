import feynmanmf;

real height = 150;
real width = 100;

CoupledClusterT1 Tai = CoupledClusterT1(
  "ai",
  angles=new real[]{110,70}
);

CoupledClusterT2 Tabij = CoupledClusterT2(
  "abij",
  angles=new real[]{70,70,110,110}
);

CoulombIntegral Vijab = shift(00,150)*CoulombIntegral(
  "ijab",
  angles=new real[]{110,110,70,70}
);

path g = (0,0) .. (100, 100);

// Clear Tabij edges, since we only need its vertices
Tabij.diagram.clear_edges();

Vijab.diagram.edges[0] = Vijab.diagram.vertices[0] .. controls (30,height/2) ..  Tabij.diagram.vertices[0];
Vijab.diagram.edges[1] = Vijab.diagram.vertices[1] .. controls (70,height/2) .. Tabij.diagram.vertices[1];
Vijab.diagram.edges[2] = Tabij.diagram.vertices[0] .. controls (-30,height/2) ..  Vijab.diagram.vertices[0];
Vijab.diagram.edges[3] = Tabij.diagram.vertices[1] .. controls (130,height/2) .. Vijab.diagram.vertices[1];
draw(Tabij);
draw(Vijab, true);

Vijab.diagram.edges[0] = Vijab.diagram.vertices[0] .. Tabij.diagram.vertices[1];
Vijab.diagram.edges[1] = Vijab.diagram.vertices[1] .. Tabij.diagram.vertices[0];
Vijab.diagram.edges[2] = Tabij.diagram.vertices[0] .. controls (-30,height/2) ..  Vijab.diagram.vertices[0];
Vijab.diagram.edges[3] = Tabij.diagram.vertices[1] .. controls (130,height/2) .. Vijab.diagram.vertices[1];
draw(shift(200,0)*Tabij);
draw(shift(200,0)*Vijab, true);

