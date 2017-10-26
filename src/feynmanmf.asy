import feynman;

real[] feynmanmf_version = {1,2};

// scale all other defaults of the feynman module appropriately
fmdefaults();

//Style for the photon lines
real photonwidth = 14;
real photonamplitude = -1;

// Change also the current pend and arrows to mock feynmanmf
currentpen = linewidth(2bp)+fontsize(20);
currentarrow = MidArrow(8bp);

/**
 * \brief Create a nice photon along a path p
 */
path photon(path p, real amp = photonamplitude, real width=photonwidth)
{
  real pathlen = arclength(p);
  // ncurls must be an even number
  int ncurls = AND(floor(pathlen/width + 1) , NOT(1));
  real actual_width = pathlen/ncurls;
  if ( amp < 0 ) {
    amp = 1.1*(sqrt(2)-1)*actual_width;
  }

  pair p1, p2, c; // Working points
  bool counter_clock_wise = false;
  real h = (amp^2 - (actual_width/2)^2)/(2*amp);
  path g;

  p1 = point(p, 0);
  for ( int i = 0; i < ncurls; i+=1 ) {
    p2 = arcpoint(p, pathlen*(i+1)/ncurls);
    c = (p1 + p2)/2;
    if (counter_clock_wise)
      c -= rotate(90)*h*(c-p1);
    else
      c += rotate(90)*h*(c-p1);
    g = g -- arc(c,p1,p2, direction=counter_clock_wise);
    // toggle between clockwise and counter clockwise rotations for the arc
    counter_clock_wise = !counter_clock_wise;
    p1 = p2;
  }
  return g;
};

/**
 * \brief Draw a photon along a path `p`
 */
void drawPhoton(
  picture pic = currentpicture,
  path p,
  real amp = photonamplitude,
  real width = photonwidth,
  pen fgpen = currentpen,
  bool erasebg = overpaint,
  pen bgpen = backgroundpen,
  real vertexangle = minvertexangle,
  real margin = linemargin
)
{
  draw(pic, photon(p, amp, width), fgpen);
};

string particle_indices = "abcdefgh";
string hole_indices = "ijklmno";

/**
 * \brief Main parent class for the diagrams.
 * Every diagram has to have a minimum of data defined.
 *   \param name Name of the diagram;
 *   \param indices Indices that the diagram contains
 *   \param edges Edges defined by the diagram
 *   \param vertices How many vertices the diagram has, for example for the
          coulomb interaction it's two, which defines two position vectors.
 */
struct Diagram {
  string name;
  string indices;
  path edges[];
  pair vertices[];
}

/**
 * \brief Casting of Diagram into string.
 * For example this is used by the operation
 *   (string) some_diagram_variable
 */
string operator cast(Diagram diagram){ return diagram.name; }

/**
 * \brief Transform a diagram by some transformation.
 * It creates a new diagram with spatial information transformed by t.
 */
Diagram operator * (transform t, Diagram diagram) {
  Diagram result;
  result.edges = t * diagram.edges;
  result.vertices = t * diagram.vertices;
  result.indices = diagram.indices;
  result.name = diagram.name;
  return result;
}

/**
 * \brief Serialization of the diagram to stdout.
 */
void write(Diagram diagram) {
  write("Name   : ", diagram.name);
  write("Indices: ", diagram.indices);
}

struct NBodyDiagram {
  Diagram diagram;
  int N;
}

#include "CoulombIntegral.asy"
