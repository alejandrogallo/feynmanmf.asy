#ifndef _COULOMBINTEGRAL_DEFINED
#define _COULOMBINTEGRAL_DEFINED

#include "Diagram.asy"

CREATE_NBODY_DIAGRAM(CoulombIntegral, 2)

/**
 * \brief CoulombIntegral class to create Coulomb terms quickly.
 * It is a 'subclass' of Diagram in so far that it has a diagram attribute.
 */
DIAGRAM_CREATE_TRANSFORM_OPERATOR(CoulombIntegral)
DIAGRAM_CREATE_CASTING_OPERATOR(CoulombIntegral)

void draw(CoulombIntegral Vpqrs, bool labels=false){
  drawPhoton(Vpqrs.diagram.vertices[0]--Vpqrs.diagram.vertices[1]);
  for ( int i = 0; i < Vpqrs.diagram.edges.length; i+=1 ) {
    drawFermion(Vpqrs.diagram.edges[i]);
  }
  if ( labels ) {
    for ( int i = 0; i < Vpqrs.diagram.edges.length; i+=1 ) {
      string index = substr(Vpqrs.diagram.indices, i, 1);
      label("$"+index+"$", Vpqrs.diagram.edges[i]);
    }
  }
};

#endif
