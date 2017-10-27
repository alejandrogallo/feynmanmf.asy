#ifndef _DIAGRAM_DEFINED
#define _DIAGRAM_DEFINED

/**
 * \brief Main parent class for the diagrams.
 * Every diagram has to have a minimum of data defined.
 *   \param name Name of the diagram;
 *   \param indices Indices that the diagram contains
 *   \param edges Edges defined by the diagram
 *   \param vertices How many vertices the diagram has, for example for the
 *        coulomb interaction it's two, which defines two position vectors.
 */
struct Diagram {
  string name;
  string particle_indices = "abcdefgh";
  string hole_indices = "ijklmno";
  string indices;
  path edges[];
  pair vertices[];
  void clear_edges() { this.edges = new path[]{}; };
  bool is_hole(int i){
    return find(this.hole_indices, substr(this.indices, i, 1)) != -1;
  };
  bool is_particle(int i){
    return find(this.particle_indices, substr(this.indices, i, 1)) != -1;
  };
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
 * \brief Define a creator of Transform * Class operator for any derived
 * structure from Diagram.
 */
#define DIAGRAM_CREATE_TRANSFORM_OPERATOR(CLASS_NAME) \
  CLASS_NAME operator * (transform t, CLASS_NAME Vpqrs) { \
    CLASS_NAME result = CLASS_NAME(Vpqrs); \
    result.diagram = t * result.diagram; \
    return result; \
  }

#define DIAGRAM_CREATE_CASTING_OPERATOR(CLASS_NAME)\
  Diagram operator cast(CLASS_NAME diagram){ \
    return diagram.diagram; \
  }

#define CREATE_NBODY_DIAGRAM(_NAME, _N)                                                                                   \
  struct  _NAME {                                                                                                         \
    Diagram diagram;                                                                                                      \
    int N = _N;                                                                                                           \
    real angles[];                                                                                                        \
    real edges_length = 100;                                                                                              \
    void operator init(                                                                                                   \
      _NAME other                                                                                                         \
    ){                                                                                                                    \
      this.diagram = other.diagram;                                                                                       \
      this.angles = other.angles;                                                                                         \
      this.edges_length = other.edges_length;                                                                             \
    };                                                                                                                    \
    void operator init(                                                                                                   \
      string indices,                                                                                                     \
      pair vertices[] = {},                                                                                               \
      real angles[] = {}                                                                                                  \
    ){                                                                                                                    \
      if (vertices.length == 0) {                                                                                         \
        for ( int i = 0; i < this.N; i+=1 ) {                                                                             \
          this.diagram.vertices[i] = (i * this.edges_length, 0);                                                          \
        }                                                                                                                 \
      } else {                                                                                                            \
        this.diagram.vertices = vertices;                                                                                 \
      }                                                                                                                   \
      if (angles.length == 0) {                                                                                           \
        for ( int i = 0; i < 2 * this.N; i+=1 ) {                                                                         \
          this.angles[i] = 0;                                                                                             \
        }                                                                                                                 \
      } else {                                                                                                            \
        this.angles = angles;                                                                                             \
      }                                                                                                                   \
      this.diagram.indices = indices;                                                                                     \
      this.diagram.name = '$X^{'+substr(this.diagram.indices, 0, this.N)+'}_{'+substr(this.diagram.indices, this.N)+'}$'; \
      if ( length(this.diagram.indices) != 2 * this.N ) {                                                                 \
        write('Indices Length of the Tensor must be ' + (string) (this.N * 2));                                           \
        exit();                                                                                                           \
      }                                                                                                                   \
      pair point;                                                                                                         \
      real angle;                                                                                                         \
      for ( int i = 0; i < length(this.diagram.indices); i+=1 ) {                                                         \
        point = this.diagram.vertices[i % this.N];                                                                        \
        angle = this.angles[i];                                                                                           \
        if (i < this.N) {                                                                                                 \
          if (find(particle_indices, substr(this.diagram.indices, i, 1)) != -1) {                                         \
            this.diagram.edges.append(point .. point + this.edges_length*dir(angle));                                     \
          } else {                                                                                                        \
            this.diagram.edges.append(point .. point + dir(-angle)*this.edges_length);                                    \
          }                                                                                                               \
        } else {                                                                                                          \
          if (find(particle_indices, substr(this.diagram.indices, i, 1)) != -1) {                                         \
            this.diagram.edges.append(point + dir(-angle)*this.edges_length .. point);                                    \
          } else {                                                                                                        \
            this.diagram.edges.append(point + this.edges_length*dir(angle) .. point);                                     \
          }                                                                                                               \
        }                                                                                                                 \
      }                                                                                                                   \
    };                                                                                                                    \
  };

#endif
