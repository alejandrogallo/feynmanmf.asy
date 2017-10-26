#ifndef _COULOMBINTEGRAL_DEFINED
#define _COULOMBINTEGRAL_DEFINED

#include "Diagram.asy"

/**
 * \brief CoulombIntegral class to create Coulomb terms quickly.
 * It is a 'subclass' of Diagram in so far that it has a diagram attribute.
 */
struct CoulombIntegral {
  Diagram diagram;
  real angles[];
  real edges_length = 100;
  void operator init(
    CoulombIntegral other
  ){
    this.diagram = other.diagram;
    this.angles = other.angles;
    this.edges_length = other.edges_length;
  };
  void operator init(
    string indices = "abij",
    pair vertices[] = {(0,0), (this.edges_length,0)},
    real angles[] = {0,0,0,0}
  ){
    this.diagram.indices = indices;
    this.diagram.vertices = vertices;
    this.diagram.name = "$V^{"+substr(this.diagram.indices, 0, 2)+"}_{"+substr(this.diagram.indices, 2)+"}$";
    this.angles = angles;
    if ( length(this.diagram.indices) != 4 ) {
      write("Length of the Vpqrs must be 4");
      exit();
    }
    pair point;
    real angle;
    for ( int i = 0; i < length(this.diagram.indices); i+=1 ) {
      point = this.diagram.vertices[i % 2];
      angle = this.angles[i];
      if (i < 2) {
        if (find(particle_indices, substr(this.diagram.indices, i, 1)) != -1) {
          this.diagram.edges.append(point .. point + this.edges_length*dir(angle));
        } else {
          this.diagram.edges.append(point .. point + dir(-angle)*this.edges_length);
        }
      } else {
        if (find(particle_indices, substr(this.diagram.indices, i, 1)) != -1) {
          this.diagram.edges.append(point + dir(-angle)*this.edges_length .. point);
        } else {
          this.diagram.edges.append(point + this.edges_length*dir(angle) .. point);
        }
      }
    }
  };
};

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
