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
a symbol associated with it. $Y$ is a set of symbols in the simulated
universe.

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
  avoid the terminology specific to the said domain for multiple reasons.
  First, the concepts are more abstract and we want to allow the modeller to
  assign model-specific meaning. For example a _cell receptor_ can be
  represented by either a tag when considering it’s existence for potential
  action, or as a slot if binding to the receptor is relevant. Similarly we
  might have used the term _sites_ as in _binding sites_ for the _slots_,
  however the _site_ representation might differ based on the modelling
  objectives.

![Object](images/object)

Now we can start defining the state of the simulated environment. For now we
ommit other components of he state and we get the following:

$$S=(G,\ldots)$$

Where G is edge labelled directed graph of objects:

$$G=(O,B)$$

Where $O$ are objects (vertices) and $E$ are bindings (edges). 

### Tags

_Tags_ represented by a symbol denotes a qualitative property of an object.
If we say an object has a tag $t$ we mean that the object is in a state $t$
(free, empty, closed, consumed, ...),
has quality $t$ (fast, white, small) or being of a class $t$ (nucleotide,
person, link), etc.

Set of symbols that represent tags in the simulated universe is
$Y^t\in Y$.


![Object tags](images/object-tags)

Presence of a tag $t$ means the object has the quality represented by the tag
$t$. The absence of the tag $t$ means that the object does not have the
represented quality. However, we can’t say whether the object can or can not
have the represented quality. This makes a difference between tags and (binary)
flags. The if we used concrete set of flags described in concept, it would be
represented as an array of boolean values in the objects. This quality
representation would always carry the information about possible flags and we
would not be able to change it.

There are no restrictions on the number of tags an object might have assigned.
As we will see later, tags can be attached (set) to and removed (unset) from
objects.

A conceptual meaning of a tag is up to the creator. For example if we had a tag
“closed”, objects without the tag does not necessarily have to be considered
“open”. Relationship between the tags, for example negation between _open_ and
_closed_, has no model equivalet in the current design and implementation of
the system. The connection remains only within the creator’s domain of
understanding.

Tags can be associated or removed from an object. When we associate a tag with
an object we say that we _set_ the tag. When we remove a tag from an object we
say that we _unset_ the tag. By unsetting a tag, we remove any information
gabout association of the tag with the object.

We will use $\hat{t}$ to denote a set of tags associated with an object or used
anywhere where tags to be associated or removed are considered.

### Slots

_Slots_ are constraints[^2] and they represent possible directed relationships
that objects can have with other objects. If there is a bond for a slot, then
the object owning the slot is called _origin_ and might become an initial node
of an edge in the object graph. An object that is being referenced is called
_target_ and becomes a terminal node in the objectgraph.

[^2]: In current design and implementation of the system the slots are special
  kind of constraints that we call _static level 0 constraints_. Once object is
  instantiated, slots can not be changed. This is preliminary design decision
  and limitation that might change in the future. By _level 0_ we mean that the
  constraints are part of the lowest model primitives and to distinguish them
  from constraints that will be introduced at higher levels.

In the system the referenced object has no explicit knowledge about being
referenced. There is no functionality besides observation that would allow
state change of a referenced object when only the referenced object is being
cosidered.

![Object slots](images/object-slots)

Potentially any object can be bound to a slot. Which object might become a
target for given slots can be inferred from the model. For more information see
section about actuators.

If we can compare slots to similar concepts from other systems or programming
languages, they are similar to object references in Smalltalk or rather
[Self](http://www.selflanguage.org) programming language.

### Object State

Every object’s state is defined by it’s properties _tags_ and _slots_: 

$$ o=(\hat{t} ,\hat{s}) $$

Where $\hat{t}\in Y^t$ and $\hat{s}\in Y^s$.

Now we can say, that the object graph can have an edge with label $s$
between objects $o_o$ and $o_t$ only when the object $o_o$ has slot $s$.


## Actuator

Dynamical behaviour of the system is described by state change elements we call
_actuators_. Actuators modify the state of an object when actuator's condition
based on state of object's context is met. We assume that all actuators operate
on all objects at once.[^3]

[^3]: This is idealized assumption which has technical implementation
  limitations that we will discuss later. This assumption also only applies to
  this level of model abstraction.

In the system we can describe two kinds of state changes: simple state changes
– an object meeting a condition changes it's state regardless of other objects,
and a state changes based on reaction of two objects. The actuator acting in
the first, simple case, is called _unary_ or _simple_ actuator and the actuator
acting in the second, reactive case, is called _binary_ or _reactive_ actuator.

Now we see that actuator has two core properties: a condition that selects
which objects from the simulation are to be considered for modification and the
modification itself. We are going to call the condition a _selector_ and we
will represent it by the letter $\sigma$. We call the part of actuator that
modifies an object a _modifier_ and we will represent it by the letter $\mu$.

Since one of our goals of the system is it's observability, we propose one more
property of an actuator: _control signal_. It is an action that is triggered at
the same time when the actuator is activated and signals a message to the
simulation environment. It has no direct effect on the state of the simulation
and can be thought as an action to communicate unidirectionally with the
observer.

Now we can define the _actuator_:

$$\alpha=(\sigma,\hat{\mu},\hat{\kappa})$$

The unary actuator can be imagined as a filter that filters all objects
one-by-one and applies a modification on those filtered through:

![Unary actuator](images/actuator-unary)

_Binary_ or _reactive_ actuator acts on two filtered objects that can be though
as "reacting" objects:

![Binary actuator](images/actuator-binary)


## Selector

Selector is a function that determines which objects are “selected” or
considered for a modification: either all objects in the simulation or objects
matching a list of _predicates_.

$$
\sigma=\begin{cases}
\sigma_\text{ALL}=\text{true} & \text{all objects}\\
\sigma_\pi & \text{objects matching predicates}\\
\end{cases}
$$

$$\sigma_\text{ALL} = \forall{o}$$
$$\sigma_\pi = \displaystyle\bigwedge_i \pi_i\\$$

## FIXME: Continue here

If multiple predicates are specified, then they are evaluated as aggregate of
logical conjunction:

$$ p=\bigwedge _{ i }^{ \quad  }{ { p }_{ i } }  $$

Due to the “minimal assumptions and mechanisms” principle, the system does not
provide extensive logic expressions, only aggregated conjunction. For example,
to implement behaviour that would be equivalent to logical disjunction of the
predicates one has to explicitly list separate selectors.

## Predicate

Predicate is a function that determines whether an object should be included in
the selection.

TODO: $\pi:O,[O]\rightarrow \text{bool}$

Predicate defines a condition and relative context of the condition that is
applied for object selection filter during evaluation. The predicate might
test state of tags or bindings. The list of possible predicates and
their evaluation to `true` is:

* `SET` _tags_
* `UNSET` _tags_
* `BOUND`: slot is bound to an object, it is not empty
* `UNBOUND`: slot is not bound to an object, is empty

![Predicate types](images/predicate-types)

Predicates are constant – their parameters are given by the model and there is
no mechanism to change them from the simulation itself. Predicates can be
changed only by the simulation controller.

### Direct vs. Indirect

Predicates can be _direct_ or _indirect_. Direct predicate is evaluated with
the same object as the object being selected. For example if we are asking for
objects with tag _open_ set, then all objects with tag _open_ set are selected:

![Tag predicate](images/predicate-tag)


Indirect predicate is applied to an object referenced through a slot in the
evaluated object. Only one level of indirection is possible.

![Indirect predicate](images/predicate-indirect)

This is useful when we want to select objects that are bound to objects with
certain properties. For example “all people owning an apple” or “all molecules
attached to a nucleotide adenine”. Objects which don’t have the slot or their
slot is empty are not evaluated.

![Indirect predicate with empty slot](images/predicate-indirect-empty)

### Predicates for Tags

Object’s tags can be tested using `SET` and `UNSET` predicates. If we consider
predicate tags _Tp_ and tags of tested object _To_, them the predicate
evaluates to true if:

`SET` _Tp_: _Tp_ ⊆ _To_

`UNSET` _Tp_: _Tp_ ∩ _To_ = ∅

In the model definition language, the keyword `SET` is omitted and only the
tags are listed.

Example:

	WHERE free DO ...
	WHERE UNSET ready DO ...

### Predicates for Bindings

Bindings or relationships can be tested for their actual existence. The two
binding-related predicates are `BOUND` and `UNBOUND`.

`BOUND` _slot_: is true if the object’s _slot_ is bound to an object.

`UNBOUND` _slot_: is true if the object’s _slot_ is empty, not bound to any object

The binding predicates don’t test for any other information of the object being
referenced. The slot might even refer to the object itself.

## Modifiers

Modifiers change state of objects. There are three kinds of modifiers: tag
modifiers or binding modifiers.

The modifiers usually operate on the objects selected by the selectors.  Which
object the modifier applies on is referred to as _current_. The _current_
object can be `THIS` or `OTHER`. `THIS` refers to an object selected by the
unary selector or by the left part of the combined selector. `OTHER` refers to
an object selected by the right part of the combined selector and it can not be
used in the unary selector.

![Target of modifiers](images/modifiers-matrix)

Note: we chose the words `THIS` and `OTHER` over the `LEFT` and `RIGHT` or
`PRIMARY` and `SECONDARY` to minimise possible keyword conflict with potential
common symbol name. It is more common to have object properties that are “on
the _left_ or _right_ side” of an object or have a “_primary_ binding site”.

If not specified otherwise the modifiers apply to the objects selected by the
_this_ selector. To make other object be current for a modifier we use `IN`
specifier:

	IN THIS modifier ...
	IN OTHER modifier ...

### Tag Modifiers

Tags can be set or unset. When tags are _set_, then the object’s tags after the
change is intersection of it’s tags before the change and the modifier’s tags.
Setting a tag can be though as assigning a quality to an object. Let us
consider tags of object being modified as _To_ and modifier’s tags _Tm_, tags
of an object after change are _Tc_:

`SET` _tags_: _Tc_ = _To_ ∪ _Tm_

Examples of tag set modifiers:

	SET open
	SET excited
	SET running, exhausted

Un-setting a set of tags results in object’s tags to not contain qualities
represented by the modifier’s tags:

`UNSET` _tags_: _Tc_ = _To_ − _Tm_

Examples of tag unset modifiers:

	UNSET ready
	UNSET available
	UNSET alive

### Binding Modifiers

An actuator can form and break relationships between objects, and thus alter
the object graph, with the two types of _binding_ modifiers:

`BIND` _source_ `TO` _target_: Create a binding that originates in the _source_
slot of the source object and points to the _target_ object. This is a graph
edge creation modifier.

`UNBIND` _source_: Make the _source_ slot to have no target reference
associated with it. This is a graph edge deletion modifier.

In _unary_ actuators the object that can be referenced in the binding are
either objects already referenced by another slot of the same object. Example:

	BIND left TO righ
	BIND operand_site TO next

In _combining_ actuators, the object that can be referenced are the same
objects as in the unary actuator, referenced as _this_, plus objects evaluated
by the second selector referenced as _other_:

	BIND head TO OTHER
	BIND active_site TO OTHER.next
	IN OTHER BIND site TO THIS

In the prototype implementation and action of binding to a slot that is already
bound results in change of the slot’s reference. Unbinding a slot that is not
bound results in no action. See developer notes for discussion about possible
change in this behaviour.

## Control Signalling

Control signalling is important part of the simulation. It allows the observer
to observe special or interesting events, register them or react on them. The
observer does not have to be necessarily a person, it might be another
automated system. No control signal has and should never have direct effect on
the state of the simulation.

We propose three kinds of signals:

* _notify_ – send a notification message to the controller without interruption
* _trap_ – interrupt the simulation and send a notification message
* _halt_ – stop the simulation without expectation of it being resumed


The _notify_ signal is asynchronous and is usually handled by a logging
component. One might use the _notify_ signal when certain simulation goal is
reached, for example if an expected reaction occurs. Notification payload
contains set of symbols that describe the event. Modeller can use them to
distinguish between different situations that occurred. Notifications can’t be
anonymous, therefore at least one symbol should be present in the payload.

It is important to note that the notifications don’t interrupt the simulation
and notification handlers must not alter the state of the simulation.

The _trap_ signal sends a message to the observer which must interrupt the
simulation and hand control to the simulation controller. It is described in a
similar way as the notification by a set of symbols. Traps are used to point
out important events in the simulation that require attention of the observer
or require the observer to act based on the trap signal. Human observers might
enter an interactive session after a trap – which might alter the simulation
state.

After interruption by a _trap_ signal, simulation can be resumed. The state of
the simulation might be modified by an external entity.

The last type of signal is _halt_ and signals to the observer that the
simulation is to be permanently interrupted. It is usually used when a state
occurs that makes no sense from the modelled problem perspective and any
farther continuation of the simulation would result in propagation of the
erroneous state therefore introducing more nonsensical inconsistencies.

After executing the _halt_ action, the simulation state is marked as _halted_.
It is up to the controller to resolve the halt event and either disallow
continuation of the simulation completely or clear the _halted_ state and allow
the simulation to be resumed. The later is not recommended.


## Open Questions about Concept Instances

The following section discusses creation and alteration of concept instances.
How the actions are implemented and what they actually mean is not yet
specified, however we ask few questions and hint towards potential direction
for solution. Concept instance dynamics is part of the system’s essentials and
therefore must be specified sooner or later.

### Creation and Deletion

One of the open questions is whether concept instances might be created and
deleted by the actuators during the simulation time or not? In the prototype
implementation we don’t allow concepts to be created by the actuators, but we
don’t prevent controllers to inject to or delete objects from the system.
Implication of such action is currently undefined.

There are few reasons why this question has not been answered yet. One is lack
of proper rationalisation and explanation of the existence alteration actions.
Other is missing rules governing the potential change of existence and last but
not least is simulation complexity of such actions.

If we want to introduce instance creation as a kind of graph  modification, we
need to understand the following:

* What does it mean that an object is created?
* What does it mean when an object is deleted?
* Is the system’s collection of objects finite or infinite?


### Mutation and Structural Alteration

In the prototype implementation the objects, once instantiated, can’t be
modified structurally. That means that the number and labelling of slots
can’t be changed neither from the inside neither from the outside of
the simulation. The only way to do the change is to do it manually or by
automation at the controller level through performing a object-level surgery
which involves creation of a new concept with new structure, instantiation of
the new concept, deletion of the existing object and rewiring the bindings.
This is very tedious operation with unspecified consequences. Moreover, the
operation might be disallowed on certain kinds of execution engines and object
stores which pre-allocate fixed-width structures based on the original concept
model prior to the simulation.

To be able to perform alteration of object structure, we need to answer or
understand the following:

* Can objects be altered individually or as a whole set through common concept
  as their template? Note that the connection between the object and the
  concept is currently lost – see the section about concept reflection.
* What is the impact of the structure change in the conceptual model to the
  simulation engine and object store implementation?
