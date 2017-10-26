import feynman;

real[] feynmanmf_version = {1,1};

// scale all other defaults of the feynman module appropriately
fmdefaults();

real photonwidth = 14;
real photonamplitude = -1;

currentpen = linewidth(2bp)+fontsize(20);
currentarrow = MidArrow(8bp);

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

struct CoulombIntegral {
  string indices;
  string name;
  real angles[];
  pair r1;
  pair r2;
  real edges_length = 100;
  path edges[];
  void operator init(
    string indices = "abij",
    pair r1 = (0,0),
    pair r2 = (this.edges_length,0),
    real angles[] = {0,0,0,0}
  ){
    this.indices = indices;
    this.r1 = r1;
    this.r2 = r2;
    this.angles = angles;
    this.name = "$V^{"+substr(this.indices, 0, 2)+"}_{"+substr(this.indices, 2)+"}$";
    if ( length(indices) != 4 ) {
      write("Length of the Vpqrs must be 4");
      exit();
    }
    pair point;
    real angle;
    for ( int i = 0; i < length(indices); i+=1 ) {
      point = (i == 0 || i == 2) ? this.r1 : this.r2;
      angle = this.angles[i];
      if (i < 2) {
        if (find(particle_indices, substr(indices, i, 1)) != -1) {
          this.edges.append(point .. point + this.edges_length*dir(angle));
        } else {
          this.edges.append(point .. point + dir(-angle)*this.edges_length);
        }
      } else {
        if (find(particle_indices, substr(indices, i, 1)) != -1) {
          this.edges.append(point + dir(-angle)*this.edges_length .. point);
        } else {
          this.edges.append(point + this.edges_length*dir(angle) .. point);
        }
      }
    }
  };
};

void draw(CoulombIntegral Vpqrs, bool labels=false){
  drawPhoton(Vpqrs.r1--Vpqrs.r2);
  for ( int i = 0; i < Vpqrs.edges.length; i+=1 ) {
    drawFermion(Vpqrs.edges[i]);
  }
  if ( labels ) {
    for ( int i = 0; i < Vpqrs.edges.length; i+=1 ) {
      string index = substr(Vpqrs.indices, i, 1);
      label("$"+index+"$", Vpqrs.edges[i]);
    }
  }
};

CoulombIntegral operator * (transform t, CoulombIntegral Vpqrs) {
  CoulombIntegral result;
  for ( int i = 0; i < Vpqrs.edges.length; i+=1 ) {
    result.edges.append(t * Vpqrs.edges[i]);
  }
  result.r1 = t * Vpqrs.r1;
  result.r2 = t * Vpqrs.r2;
  result.indices = Vpqrs.indices;
  result.name = Vpqrs.name;
  return result;
}
