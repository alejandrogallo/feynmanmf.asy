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

#endif
