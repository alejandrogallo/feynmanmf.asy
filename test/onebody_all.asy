import feynmanmf;

void draw_fock(OneBodyDiagram term, bool labels=false){
  draw(term, labels);
  filldraw(shift(term.diagram.vertices[0]) * scale(18) * unitcircle, white);
  label(term.diagram.name, term.diagram.vertices[0]);
};

OneBodyDiagram Fij = OneBodyDiagram("ij", angles=new real[]{90, 90});
OneBodyDiagram Fai = OneBodyDiagram("ai", angles=new real[]{70, 110});
OneBodyDiagram Fia = OneBodyDiagram("ia", angles=new real[]{110, 70});
OneBodyDiagram Fab = OneBodyDiagram("ab", angles=new real[]{90, 90});

OneBodyDiagram diagrams[] = {Fij, Fai, Fia, Fab};

for ( int i = 0; i < diagrams.length; i+=1 ) {
  draw_fock(shift((i*100, 0)) * diagrams[i], true);
}
