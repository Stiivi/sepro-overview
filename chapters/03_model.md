# Model

Model encapsulates description of conceptual structures, their behaviour,
initial conditions and observed properties. Parts of the model are:

* _Concepts_ – description of atomic entities
* _Actuators_ – reactive behaviour in form of conditioned modifiers
* _Structures_ – compounds of potentially linked objects 
* _Worlds_ – collections of initial set of objects
* _Measures_ – collection of properties and aggregates that  are to be observed
  and potentially captured by a logging mechanism

## Concept

_Concept_ is a description of the smallest, indivisible entity representing
relevancy, finest grain of the observed hierarchy of model composition.
Concepts are identifier by a _symbol_ that is unique to the model.

Concepts might have qualitative and countable (quantitative) properties and
they also might form directed relationships. The quantitative properties are
represented by any number of _tags_, the quantitative properties are
represented by given number of _counters_ and potential relationships of given
number, which are named _slots_. Here is a visual representation of a concept
with mentioned properties:

![Object](images/object)

Concrete instances of concepts are _objects_ – they form the composition of the
simulated world. Concept describes initial state of an object and it’s static
structure. Concepts can be though as recipes for object instantiation. The
object data structure is depicted in the following image:

![Object properties](images/properties)

Examples of concepts:

	CONCEPT person
	CONCEPT box
	CONCEPT cell


#### Of Concept Terminology

Even-though the system is inspired by bio-chemical processes, we try to avoid
the terminology specific to the said domain for multiple reasons. First, the
concepts are more abstract and we want to allow the modeller to assign
model-specific meaning. For example a _cell receptor_ can be represented by
either a tag when considering it’s existence for potential action, or as a slot
if binding to the receptor is relevant, or even as a counter if quantity of the
receptors are relevant. Similarly we might have used the term _sites_ as in
_binding sites_ for the _slots_, however the _site_ representation might differ
based on the modelling objectives.

#### Of Concept Reflection

Association of concept to an object might not be present once the object is
instantiated. Unlike classes from dynamic object oriented programming
languages, concept identity can not be reflected from object instances. Under
default circumstances, the concept identity might be assigned as a special tag
which represents the originating concept. However, this tag has no different
treatment in the computation than any other tag. It is not guaranteed not to be
dis-associated with the owning object. See more information in the discussion
about tags.

Nevertheless, the concept can potentially be inferred from static properties if
there is no ambiguity between concept properties at the model level (same fixed
properties) and from space of behavioural side effects (which might be too
complex). If two original concepts have the same properties, for example
counter _count_ and no slots, then we can’t tell which object represents which
concept if the original concept tag is not preserved.

Concept reflection can be implemented as a property of the model by assuring
that there are no rules in the model that would induce removal of the concept
tag. Higher level applications might have validation, user-oriented inputs and
visualisation for this feature.

### Objects

Objects are physical instances of concepts represent the state of the computation. Even-though the more appropriate name would be _conceptual atoms_, we borrow the term _object_ from the object oriented programming languages for familiarity.

In current implementation there is no other way to add or remove objects to the computation from within the computation. Objects can not initiate creation or removal of other objects. This constraint requires further research.

**TODO:** elaborate more about dynamic objects - add/delete, concept creation/relevance

### Symbols

Symbols are strings that represent names or labels in the system. Everything that can be named has a symbol associated with it.

In the early implementation, there is no distinction between symbols, they are typeless. In the future implementations, one symbol must label only one kind of entities or properties – symbols are typed. For example, symbol representing a tag will not be able to represent a counter and vice versa.

### Tags

_Tags_ represent qualitative properties of a concept. 
The _tag_ _t_ represents atom being in a state _t_ (free, closed, consumed, …), having quality _t_ (white, small, fast, …), being of a class _t_ (connector, nucleotide, person, …), etc.

![Object tags](images/object-tags)

If there is conceptual relationship between the tags, for example negation
between _open_ and _closed_, the relationship has no model representation and
remains only at the creator’s level.

Presence of a tag _t_ means the object has the quality represented by the tag
_t_. The absence of the tag _t_ means that the object does not have the
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
for memory optimisation purposes should not have any effect on the computation
itself and should not provide any information contained in the annotation to
the computation.

Tags can be _set_ or _unset_. By setting a tag we associate the tag with an
object. By unsetting a tag, we remove any information about association of the
tag with the object.

### Counters

_Counters_ are quantitative properties of a concept. The quantity stored is a
number of instances of countable quality associated with the object. A counter
can be imagined as a container able to hold multiple copies of the same tag.
The only difference is that the _counter_ is a static property of an object.

![Object counters](images/object-counters)

Counters, being static properties can not be dis-associated from neither
associated with an object during run time. At least not in this early
implementation. Impact of this feature requires more research.

Counters can be changed by incrementing or decrementing their values. Counters
can be cleared to be zero and they can be tested whether they are zero.

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

World defines initial collection of objects in the computation, their state and
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

The _world_ container can be composed of objects and structures, therefore it creates two-level structural hierarchy. Model structures can be composed only of objects, recursive nesting of structures is not yet permitted (see the development notes for reasoning).

In the prototype implementation we don’t allow recursive definition structures – that means that use of other structures as structure elements is not possible. Even though this restriction might be changed in the future, introduction of recursion should respect potential negative impact on the engine implementation.

### Root

There might be situations where we need to consider a global state in a computation. For that purpose there is one special object that we call _root_. It is the only object that can be explicitly globally referenced. Every computation has a root object, event-though it might be unused. Default root object is empty, has no properties and no slots.
