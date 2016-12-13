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

Concepts can specify initial state and level 0 constraints of an objects: 

    CONCEPT link
        TAG new
        SLOT next

    CONCEPT box
        TAG closed
        SLOT content

    CONCEPT nucleotide
        TAG adenosine

    CONCEPT person
        TAG hungry
        TAG tired
        SLOT bag
        SLOT hand

## World

World defines initial collection of objects in the simulation, their state and
relationships. The _world_ can be though as an oriented graph structure.

### Structure

Structure defines a simple group of object in form of a graph. The structure
contains list of concepts to be instantiated within the structure, bindings
within the structure and interface towards the outside of the structure.

Examples of primitive structures:

![Primitive structures](images/structures)

The structure has a form:

	STRUCT name
	    ... structure contents ...

The contents is mostly instance specification, for example: `OBJECT receptor`
will result in one instance of concept `receptor`, `OBJECT link, link, link`
will result in three instances of a concept `link`. If we want many instances
of a single concept we can specify that as:

`OBJECT` _concept_ `*` _count_

As in `OBJECT link * 100` to get 100 instances of the concept `link`.

If we want to refer to the instances within the structure, for example to crate
a binding with that instance, we might give it a name alias:

	OBJECT link AS head, link AS middle, link AS tail

By default alias of an object will be the same as the concept name. If there
are multiple instances of the same concept without and explicit alias, then the
reference is undefined.

#### Bindings

Bindings within the structure can be created between uniquely named objects.
The binding definition is very similar to the `BIND` modifier:

`BIND` _source_`.`_slot_ `TO` _target_

For example:

	BIND head.next TO middle
	BIND middle.next TO tail

Two of the structures depicted above can be defined for example as follows:

	STRUCT triplet
	   OBJECT atom AS left, OBJECT atom AS right
	   OBJECT large_atom
	   BIND large_atom.left TO left
	   BIND large_atom TO right
	
	STRUCT chain
	   OBJECT head
	   OBJECT link AS l1, link AS l2
	   OBJECT tail
	   BIND head.next TO l1
	   BIND l1.next TO l2
	   BIND l2.next TO tail

The other structures are constructed in a similar way.

To be able to bind structures with other objects or other structures, we need
to specify where the external bindings are connected to the internal parts of
the structure or how the internal parts of the structure connects to the
external objects.

The whole structure is represented by one object called _target_. Whenever we
`BIND` to the structure the target end of the binding is the object marked as
_target_. This explicit representation exists only in the model and disappears
after structure is instantiated.

Similarly when we model an instance of a structure and bind the structure to
other objects, we actually bind slots of objects inside of the structure. Slots
which can be bound can be exposed as structure’s _slots_.

Here is an example of a 4-object cycle structure where the “east” object is the
target object and it has two slots exposed: “west” and “south”. The structure
acts in the model as an object with two slots:

![Encapsulated structure](images/structures-group)

#### Limits of Structural Recursion

The _world_ container can be composed of objects and structures, therefore it
creates two-level structural hierarchy. Model structures can be composed only
of objects, recursive nesting of structures is not yet permitted (see the
development notes for reasoning).

In the prototype implementation we don’t allow recursive definition structures
– that means that use of other structures as structure elements is not
possible. Even though this restriction might be changed in the future,
introduction of recursion should respect potential negative impact on the
engine implementation.

## Actuator

The actuators start with the `WHERE` keyword. The unary actuator has the form:

	WHERE predicates ... DO modifiers ...

The binary actuator has the form:

	WHERE predicates ... ON predicates ... DO modifiers ...


### Selector

* `ALL` – all objects, no filter is applied
* list of _predicates_ – all objects which match the predicates

Example:

    WHERE ALL DO ...


### Control Signalling

Control signals are specified in the model in very similar way as the
modifiers. They are part of the same clause:

    WHERE ... DO ... HALT
    WHERE ... DO ... NOTIFY ping
    WHERE ... DO ... NOTIFY area, flooded
    WHERE ... DO ... TRAP goal_reached

