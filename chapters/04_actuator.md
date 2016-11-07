## Actuator

Behaviour of the system is described by actuators. The actuators describe how
the objects change based on their own state or a state of other objects
involved in the evaluation. Main elements of the actuator that are involved in
the computation are _selector_ and _modifier_. The _selector_ specifies which
objects are involved in the state change and _modifier_ specifies what change
is applied to the selected objects.  Actuator can be though as a conditioned
modifier. 

Actuator might optionally contain _control actions_ which are affecting the
computation controller but have no direct effect on the computation.

The actuator might be either _unary_ or _binary_. The _unary_ actuator applies
modifiers on each object from a selected set individually. The unary actuator
has form:

	WHERE predicates ... DO modifiers ...

![Unary actuator](images/actuator-unary)

_Binary_ or rather _combined_ actuator applies modifiers on a cartesian product
of two selected sets of objects. The binary actuator has form:

	WHERE predicates ... ON predicates ... DO modifiers ...

![Binary actuator](images/actuator-binary)


### Selector

Selector defines which objects are “selected” for modification or a control
action. The selector might select all objects without any filtering, objects
matching a set of predicates or a single _root_ object if it matches a set of
predicates:

* `ALL` – all objects, no filter is applied
* `ROOT` and optional list of predicates – the _root_ object. If predicates are
  specified then the root object only when it matches the predicates
* list of _predicates_ – all objects which match the predicates

![Selector types](images/selector-types)

If multiple predicates are specified, then they are evaluated as aggregate of
logical conjunction:

$$ p=\bigwedge _{ i }^{ \quad  }{ { p }_{ i } }  $$

Due to the “minimal assumptions and mechanisms” principle, the system does not
provide extensive logic expressions, only aggregated conjunction. For example,
to implement behaviour that would be equivalent to logical disjunction of the
predicates one has to explicitly list separate selectors.

### Predicate

Predicate defines a condition and relative context of the condition that is
applied for object selection filter during computation. The predicate might
test state of tags, counters or bindings. The list of possible predicates and
their evaluation to `true` is:

* `SET` _tags_
* `UNSET` _tags_
* `ZERO` _counter_: value of _counter_ is zero
* `>` _value_: _counter_ is greater than a constant _value_
* `<` _value_: _counter_ is less than a constant _value_
* `BOUND`: slot is bound to an object, it is not empty
* `UNBOUND`: slot is not bound to an object, is empty

![Predicate types](images/predicate-types)

Predicates are constant – their parameters are given by the model and there is
no mechanism to change them from the computation itself. Predicates can be
changed only by the computation controller.

#### Direct vs. Indirect

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

#### Predicates for Tags

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

#### Predicates for Counters

Counters can be tested for having a zero value or be compared against a
constant contained the predicate:

`ZERO` _counter_: is true when the value of _counter_ is 0.

There is no equality operator (`=`) that tests whether a _counter_ is equal to
a constant value. Reason is that the state changes should occur only when there
is “enough of something” or “not yet enough of something”. Given distributed
and complex nature of the computation, equality comparison might not be
properly evaluated in every desired case. Equality comparator is very sensitive
to the order of computation and predicate might miss the exact moment where
equality might be measured. Inequality comparators are more resistant to the
internal computation order.

The following two comparison operators are present in the computation engine
prototype, however they are questionable whether they should exist. They have
some backing in form such as reactions to fixed “quantifiable presence of a
substance” or “quantifiable energy”. However, they can be abused to form an
equality operator and they also increase computational complexity.

_counter_ `>` _constant_: is true when the value of _counter_ is greater than
_constant_

_couter_ `<` _constant_: is true when the value of _counter_ is less than
_constant_

Their use is preliminarily discouraged.

#### Predicates for Bindings

Bindings or relationships can be tested for their actual existence. The two
binding-related predicates are `BOUND` and `UNBOUND`.

`BOUND` _slot_: is true if the object’s _slot_ is bound to an object.

`UNBOUND` _slot_: is true if the object’s _slot_ is empty, not bound to any object

The binding predicates don’t test for any other information of the object being
referenced. The slot might even refer to the object itself.

### Modifiers

Modifiers change state of objects. There are three kinds of modifiers: tag
modifiers, counter modifiers and relationship or binding modifiers.

The modifiers usually operate on the objects selected by the selectors, but
they can also be applied on the root object. Which object the modifier applies
on is referred to as _current_. The _current_ object can be `THIS`, `OTHER` or
`ROOT`. `THIS` refers to an object selected by the unary selector or by the
left part of the combined selector. `OTHER` refers to an object selected by the
right part of the combined selector and it can not be used in the unary
selector. `ROOT` always refers to the singleton root object.

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

#### Tag Modifiers

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

Unsetting a set of tags results in object’s tags to not contain qualities
represented by the modifier’s tags:

`UNSET` _tags_: _Tc_ = _To_ − _Tm_

Examples of tag unset modifiers:

	UNSET ready
	UNSET available
	UNSET alive

#### Counter Modifiers

State of the counters can be changed in three ways: increase value, decrease
value or clear the counter – make it zero.

`INC` _counter_: counter ← counter + 1 

`DEC` _counter_: counter ← counter - 1

`CLEAR` _counter_: counter ← 0

Example of counter modifiers:

	DEC energy
	INC health

Counters have no upper bounds. General rule is to maintain relatively small
values in the counters. Implementation a computation engine might impose upper
bound based on capabilities of the platform the engine is operating on. The
bound should be “large enough” to satisfy most of the modelling needs. Model
creators and computation engine designers should be aware of the limits and
adapt their strategy accordingly.

Attempt to decrease value of counters where value is zero  results in counter
remaining zero. This is preliminary recommended behaviour in the prototype for
simplicity. This behaviour might change. See developer notes for discussion.

#### Binding Modifiers

An actuator can form and break relationships between objects, and thus alter
the object graph, with the two types of _binding_ modifiers:

`BIND` _source_ `TO` _target_: Create a binding that originates in the _source_
slot of the source object and points to the _target_ object. This is a graph
edge creation modifier.

`UNBIND` _source_: Make the _source_ slot to have no target reference
associated with it. This is a graph edge deletion modifier.

In _unary_ actuators the object that can be referenced in the binding are
either objects already referenced by another slot of the same object or the
_root_ object. Example:

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

### Control Actions

Actuators might trigger actions affecting the controller but  have no direct
effect on the computation itself. The control actions are: `NOTIFY`, `TRAP` and
`HALT`.

`NOTIFY` sends a notification message to the controller, usually handled by a
logging component. Notification payload contains set of symbols. Notifications
can’t be anonymous, therefore at least one symbol should be present in the
payload. Notifications don’t interrupt the computation and notification
handlers are not allowed to alter the state of the computation.

`TRAP` interrupts the computation and sends a message to the controller.
Similar to the notifications, traps are described by set of symbols. Traps are
used to hand control to the computation controller.

The controller receives counts of traps that occurred and may hand the control
to the user or other systems. Computation can be resumed after a trap
interruption and the trap handlers are allowed to alter the state of the
computation.

`HALT` is a special control action that interrupts the computation and
disallows it’s continuation. It can be thought as a `TRAP` with special meaning
and treatment. The action can be used to signal when an invalid computation
state has been reached and it makes no sense to continue the computation.

After executing the `HALT` action, the system is marked as _halted_. It is up
to the controller to resolve the halt event and either disallow continuation of
the computation completely or clear the _halted_ state and allow the
computation to be resumed.

### Open Questions about Concept Instances

The following section discusses creation and alteration of concept instances.
How the actions are implemented and what they actually mean is not yet
specified, however we ask few questions and hint towards potential direction
for solution. Concept instance dynamics is part of the system’s essentials and
therefore must be specified sooner or later.

#### Creation and Deletion

One of the open questions is whether concept instances might be created and
deleted by the actuators during the computation time or not? In the prototype
implementation we don’t allow concepts to be created by the actuators, but we
don’t prevent controllers to inject to or delete objects from the system.
Implication of such action is currently undefined.

There are few reasons why this question has not been answered yet. One is lack
of proper rationalisation and explanation of the existence alteration actions.
Other is missing rules governing the potential change of existence and last but
not least is computational complexity of such actions.

If we want to introduce instance creation as a kind of graph  modification, we
need to understand the following:

* What does it mean that an object is created?
* What does it mean when an object is deleted?
* Is the system’s collection of objects finite or infinite?


#### Mutation and Structural Alteration

In the prototype implementation the objects, once instantiated, can’t be
modified structurally. That means that the number and labelling of slots or
counters can’t be changed neither from the inside neither from the outside of
the computation. The only way to do the change is to do it manually or by
automation at the controller level through performing a object-level surgery
which involves creation of a new concept with new structure, instantiation of
the new concept, deletion of the existing object and rewiring the bindings.
This is very tedious operation with unspecified consequences. Moreover, the
operation might be disallowed on certain kinds of execution engines and object
stores which pre-allocate fixed-width structures based on the original concept
model prior to computation.

To be able to perform alteration of object structure, we need to answer or
understand the following:

* Can objects be altered individually or as a whole set through common concept
  as their template? Note that the connection between the object and the
  concept is currently lost – see the section about concept reflection.
* What is the impact of the structure change in the conceptual model to the
  computation engine and object store implementation?
