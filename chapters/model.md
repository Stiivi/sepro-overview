# Model

Model of the simulated universe or environment describes it's components,
behaviour and initial state. The core of the simulated environment has three
aspects: structure, qualitative properties and behaviour. The structure is
represented graph where nodes are _objects_ with qualitative properties.  The
behaviour is described through state change rules which we call _actuators_. We
will describe the objects and actuators later in more detail. 

Before we explain the components of the simulated universe, we need to
introduce a _symbol_: a sequence of characters and is used as a label of
entities or their properties. Everything that can be referred to by a name has
a symbol associated with it.

State of the simulated environment:

$$S=(G,A)$$

Where G is edge labelled directed graph of objects:

$$G=(O,B)$$

Where $O$ are objects (vertices) and $E$ are bindings (edges). 

## Objects

_Object_ is the smallest, indivisible entity representing an instance of
relevancy of a concept within the simulated universe. It is the finest grain of
the observed hierarchy of model composition. Alternative appropriate name
would be _conceptual atom_, however we borrow the term _object_ from the object
oriented programming languages for familiarity.

Objects might have qualitative properties. The quantitative properties are
represented by set of symbols which we are going to call _tags_. 
Objects might form _bindings_ (relationships) with other objects.

A binding between two objects is represented as an edge in the object graph. An
edge is a tuple $(o_i,o_t,s)$ where $o_i$ is initial object (node), $o_t$ is
terminal object (node) and $s$ is a _slot_[^1] name - the edge label. There can
be only one edge with object $o_i$ and slot $s$ in the graph.  Objects have
fixed set of _slots_ that is predetermined at the moment of object's
instantiation.

[^1]: Even-though the system is inspired by bio-chemical processes, we try to
avoid the terminology specific to the said domain for multiple reasons. First,
the concepts are more abstract and we want to allow the modeller to assign
model-specific meaning. For example a _cell receptor_ can be represented by
either a tag when considering it’s existence for potential action, or as a slot
if binding to the receptor is relevant. Similarly we might have used the term
_sites_ as in _binding sites_ for the _slots_, however the _site_
representation might differ based on the modelling objectives.

![Object](images/object)

### Concepts

Objects are instantiated from object prototypes or templates called _concepts_.
The _concepts_ describe initial state of an object as well as fixed properties
of the objects which can not be changed later during the simulation. The fixed
properties can be thought as a domain model constraints. Concepts can be though
as recipes for object instantiation.

Examples of concepts in the modelling language:

	CONCEPT cell
	CONCEPT person
	CONCEPT box

Association of concept to an object might not be present once the object is
instantiated. Unlike classes from dynamic object oriented programming
languages, concept identity can not be reflected directly from the object
instances. Under standard circumstances, the concept identity might be assigned
as a special _tag_ which represents the originating concept. However, this tag
has no different treatment in the simulation than any other tag. It is not
guaranteed not to be dis-associated with the owning object. See more
information in the discussion about tags.

### Tags

_Tags_ represented by a symbol denotes a qualitative property of an object.
If we say an object has a tag $t$ we mean that the object is in a state $t$
(free, empty, closed, consumed, ...),
has quality $t$ (fast, white, small) or being of a class $t$ (nucleotide,
person, link), etc.

![Object tags](images/object-tags)

At this level there are no restrictions on the number of tags an object might
have assigned.  As we will see later, tags can be attached (set) to and removed
(unset) from objects.

If there is conceptual relationship between the tags, for example negation
between _open_ and _closed_, the relationship has no model representation in
current design and remains only within the creator’s domain of understanding.

Presence of a tag $t$ means the object has the quality represented by the tag
$t$. The absence of the tag $t$ means that the object does not have the
represented quality. However, we can’t say whether the object can or can not
have the represented quality. This makes a difference between tags and (binary)
flags. The if we used concrete set of flags described in concept, it would be
represented as an array of boolean values in the objects. This quality
representation would always carry the information about possible flags and we
would not be able to change it.

Meaning of a tag is up to the creator. For example if we had a tag “closed”,
objects without the tag does not necessarily have to be considered “open”.

Examples of tags:

	TAG free
	TAG nucleotide
	TAG hungry, tired  

Tags can be implemented either as a dynamic set of symbols or as a binary
vector. If implemented as a binary vector, the size of the vector is virtually
equal to the number of tag symbols in the system since any of known tags can be
potentially assigned to any object. Shortening and annotation of such vector
for memory optimisation purposes should not have any effect on the simulation
itself and should not provide any information contained in the annotation to
the simulation.

Tags can be _set_ or _unset_. By setting a tag we associate the tag with an
object. By unsetting a tag, we remove any information about association of the
tag with the object.

### Slots

_Slots_ represent possible one-way relationships that the objects of the
concept can have with other objects. If there is a bond for a slot, then the
object owning the slot is called _source_ and the referenced object is called
_target_. The referenced object has no explicit knowledge about being
referenced.

![Object slots](images/object-slots)

Potentially any object can be bound to a slot. Which object might be targets
for given slots can be inferred from the model.

Slots are similar to object references in Smalltalk.

### Representation

Every object’s state is defined by it’s properties: _tags_ and _counters_: 


$$ o=(\overline{t} ,\overline{c}) $$

The _tags_ can be represented either as a vector of booleans with the same size
as number of tag symbols in the whole model or as a set.


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

### Root

There might be situations where we need to consider a global state in a
simulation. For that purpose there is one special object that we call _root_.
It is the only object that can be explicitly globally referenced. Every
simulation has a root object, event-though it might be unused. Default root
object is empty, has no properties and no slots.
