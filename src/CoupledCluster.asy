#ifndef _COUPLED_CLUSTER_DEFINED
#define _COUPLED_CLUSTER_DEFINED

#include "Diagram.asy"

CREATE_NBODY_DIAGRAM(CoupledClusterT1, 1)
DIAGRAM_CREATE_TRANSFORM_OPERATOR(CoupledClusterT1)
DIAGRAM_CREATE_CASTING_OPERATOR(CoupledClusterT1)

CREATE_NBODY_DIAGRAM(CoupledClusterT2, 2)
DIAGRAM_CREATE_TRANSFORM_OPERATOR(CoupledClusterT2)
DIAGRAM_CREATE_CASTING_OPERATOR(CoupledClusterT2)

CREATE_NBODY_DIAGRAM(CoupledClusterT3, 3)
DIAGRAM_CREATE_TRANSFORM_OPERATOR(CoupledClusterT3)
DIAGRAM_CREATE_CASTING_OPERATOR(CoupledClusterT3)


void draw(CoupledClusterT1 term, bool labels=false){
  real XProj = dot(
    min(term.diagram.edges[0]) - term.diagram.vertices[0],
    (1,0)
  );
  pair vertex_l = term.diagram.vertices[0] + (-XProj,0);
  pair vertex_r = term.diagram.vertices[0] + (XProj,0);
  draw(vertex_l -- vertex_r);
  for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
    drawFermion(term.diagram.edges[i]);
  }
  if ( labels ) {
    for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
      string index = substr(term.diagram.indices, i, 1);
      label("$"+index+"$", term.diagram.edges[i]);
    }
  }
};

void draw(CoupledClusterT2 term, bool labels=false){
  draw(term.diagram.vertices[0] -- term.diagram.vertices[1]);
  for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
    drawFermion(term.diagram.edges[i]);
  }
  if ( labels ) {
    for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
      string index = substr(term.diagram.indices, i, 1);
      label("$"+index+"$", term.diagram.edges[i]);
    }
  }
};

void draw(CoupledClusterT3 term, bool labels=false){
  draw(
    term.diagram.vertices[0] -- \
    term.diagram.vertices[term.diagram.vertices.length-1]
  );
  for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
    drawFermion(term.diagram.edges[i]);
  }
  if ( labels ) {
    for ( int i = 0; i < term.diagram.edges.length; i+=1 ) {
      string index = substr(term.diagram.indices, i, 1);
      label("$"+index+"$", term.diagram.edges[i]);
    }
  }
};

#endif
