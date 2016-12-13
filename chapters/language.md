# Language

Here we propose a domain specific language for describing problems in the
simulation system Sepro. The language covers three areas of the model: primary
structure – objects and behavior of the system, secondary structure – initial
graphs of a simulation and observer related information.

![Model Language Overview](images/model-language-overview)

## Structure and Behavior

### Concepts

![Concept](images/grammar-concept)
![Concept Member](images/grammar-concept-member)

Objects in the simulation are instantiated from object prototypes or templates
called _concepts_.  The _concepts_ describe initial state of an object as well
as fixed properties of the objects which can not be changed later during the
simulation. The fixed properties can be thought as a domain model constraints.
Concepts can be though as recipes for object instantiation.

Examples of concepts in the modelling language:

	CONCEPT cell
	CONCEPT person
	CONCEPT box

Despite their resemblance, concepts should rather be not compared to classes
from dynamic object oriented programming languages. Once the object is
instantiated, association of concept to an object might not be present and
concept can not be inferred directly from the object instances.  Simulator
engine implementations are recommended to associate concept name to a newly
instantiated object. However, this tag has no different treatment in the
simulation than any other tag. It is not guaranteed not to be dis-associated
with the owning object.

Concepts can specify initial state of an object. Tags can be associated with
new instances:

    CONCEPT link
        TAG new

    CONCEPT box
        TAG closed

    CONCEPT nucleotide
        TAG adenosine

    CONCEPT person
        TAG hungry
        TAG tired


