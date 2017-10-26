import feynman;

real[] feynmanmf_version = {1,1};

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

CoulombIntegral operator * (transform t, CoulombIntegral Vpqrs) {
  CoulombIntegral result = CoulombIntegral(Vpqrs);
  result.diagram = t * result.diagram;
  return result;
}

Diagram operator cast(CoulombIntegral Vpqrs){
  return Vpqrs.diagram;
}

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

