# Computation

The Sepro computation evaluates the state of conceptual dynamic system in
discrete time by iteration. Ideal computation would be when a computation of
every element of the system – every object and every actuator – would happen in
parallel at the same time. We call this _massively parallel ideal computation_.
Since this kind of computation is not easy to achieve with current technology
we have to reach for simpler methods and impose certain limitations to the
system.

The massively parallel ideal computation has the following properties:

* modifiers are applied to objects satisfying actuator’s predicate right when
  the predicate condition is met
* modifications happen in parallel without given order
* time is not globally relevant

## Order and Time

Given inspiration in biochemistry, the nature of the system does not impose any
evaluation order of the actuators and objects. However, to be able to perform
the computation on Von-Neumann computer architecture which is sequential, we
need to define the order of computation, and understand it’s impact on the
computation result. The emphasis is more on the explicit impact description
than on the actual order definition. The computation order is a meta-problem
that we are not trying to solve yet, but we need to propose few solution to
start with.

Let us have the system defined by objects _O_ – instances of concepts, their
bindings _B_ – relationships and actuators. The system can be imagined as a
directed graph _G_ with objects as nodes and bindings as edges coupled by
behavioural information _A_. The graph content is conceptually separate from
the actuators for potential computation variations over the same graph with
different set of actuators where difference between outcomes is to be observed.

$$ S=(G,A)=((O,B),A) $$

**Assumption:** We consider time to be global, that means that time is the same
for every entity (object, binding, actuator,…) of the system.

Having global time of discrete nature, we can refer to each state by global
time reference _t_ and can say that state of the system at time _t_ is
described as a state of objects and bindings at time _t_.

$$ S=({G}_{t},{A}_{t})=(({O}_{t},B_t),A_t) $$

Note that the actuators remain constant in regards to the simulation. Let us
postpone the possibility of changing the actuators at the controller’s level
for now. We still keep them as a part of the simulation state nevertheless.

**Def.:** _Step_ is a time unit during which every actuator is evaluated
against every object in the system at most once. 

**Def.:** _Step computation_ is a function that defines transition of the state
of the system’s graph within one time unit.

$$ F(S_t)=S_{t+1}=(F(G_t,A_t),A_t) $$

Within single step of computation, the following must happen:

* every enabled actuator is considered
* every object in the system is associated with one or more considered
  actuators if the actuator’s predicate matches the object’s state 
* actuators modifiers are applied to the actuator’s associated objects
* actuator’s control actions are collected if the actuator had objects
  associated

The order how the actuators, their evaluation and application is  executed is
left to the concrete implementation of the computation engine. The decision
whether the computation is performed in parallel and what kind of parallelism
is used is an implementation choice of the computation engine.

It has to be remembered that, as mentioned before, the computation might be
highly sensitive to the order of execution. We will propose one of the methods
here.

Additionally, the following non-computation related control and measurement
actions happen after the computation step is finished:

* control actions are passed to the observer
* measurement of the system is performed and passed to the logger

## Sequential Scan Computation Method

Here we propose a simple computation method: _Sequential scans with actuators
first_. This method performs the _step computation_ in a single thread thread
and considers the time to be system-global.

Unlike in nature, we are not going to imitate “real parallelism” at the level
of objects and their properties. At least not yet. By “real parallelism” we
mean a system where all elements can change their state at any time without any
shared threads of control flow between the elements. 

We are not going to apply all the modifiers on all the objects at the same
time. We serialise the computation by applying the modifiers on the objects in
the order as given by a lazy selection algorithm, described below. The method
is analogous to vertical and horizontal line scan of a CRT screen where an
object can be seen as a point on the screen and where the beam traverses the
points in fixed pattern. One simulation step can be modelled by a single full
scan of the whole screen. Once the beam touches a point on the screen, it does
not go back within the same full screen scan:

!["TV screen" scan](images/evaluation-cartesian-scan)

The computation step can be described in a pseudo-language as:

	FOR actuator IN unary actuators DO:
	    evaluate unary actuator
	
	FOR actuator IN combined actuators DO:
	    evaluate combined actuator

The evaluation of unary actuator is a single pass through the lazy selection of
objects matching actuator’s predicates:

	selection S := get selection of objects for actuator
	
	FOR object IN selection S DO:
	    apply actuator modifiers to object

![Unary scan](images/evaluation-unary-scan)

The evaluation of combined actuator _A_ is a nested loop forming cartesian
product between two selected sets of objects:

	selection L := GET objects matching "this" selector of actuator A
	selection R := GET objects matching "other" selector of actuator A
	
	FOR l-object IN selection L DO:
	    FOR r-object IN selection R do:
	        apply combined actuator modifiers to l-object and r-object
	        IF l-object does not match actuator's "this" selector DO:
	            CONTINUE with next L

![Cartesian scan](images/evaluation-cartesian-scan-2)

The actuators are applied on the tuples from the cartesian product in the
following order:

![Evaluation tuples](images/evaluation-tuples)

After application of object’s modifiers, we have to make sure that the
outermost loop carrying the _l-object_ should still be considered in the
computation – whether it still matches the original predicate. If the
_l-object_ does not match the predicate any more, we can not continue with the
rest of the objects in the _R_ selection.

![Skipped evaluation](images/evaluation-skipped)

There is a limitation of this combined computation. Once the _l-object_ was
considered for computation and was discarded, it is not brought back to the
computation even though it might be valid again due to later application of
modifiers to the object.

More information about _lazy selection_ is in the following section.

### Object Selection

The objective of object selection process is to determine which actuators
affect which objects by evaluating actuator’s predicates. There might be three
kinds of selections:

* full selection – all objects in the computation
* filter selection – objects in the computation that match compound predicate
* concrete selection – explicit list of objects

The selections are defined as follows:

**Def.:** _Concrete selection_ is an explicit set of known object references.

**Def.:** _Iterator_ is a function bound to a structure that traverses a
collection of entities. Iterator instance is an iterator initialised with a
sequence. For example, given a set A = {10, 20, 30} and sequential iterator _I_
initialized with the set _i_ = _I(A)_. Subsequent evaluation of the function
_i()_ would yield items 10, 20 and 30 separately.

**Def.:** Full selection is an iterator of all objects in the computation.

**Def.:** _Lazy filter_ is an iterator with a set of predicates. The iterator
traverses given collection once and yields elements which match given
predicates. Every object is visited for evaluation only once, if the status of
the object changes after evaluation, the object is not visited again. All
objects in the collection that have not been yet visited are treated as
potential candidates.

**Def.:** _Filter selection_ is a lazy filter applied to all objects or another
selection.

The filter selection can be though as a reference to potential candidates in
the system. The property of the filter selection is opposite to the iteration
of the results of a SQL `SELECT` statement. In SQL the result set is evaluated
and it is guaranteed to remain the same from the time of actual query execution
to it’s whole consumption or abandonment. Any modifications happening on the
original data source has no effect to the already running query. This is
expected behaviour for the relational database use-case purposes.

![Filtered selection](images/evaluation-filter-selection)

Our model requires the dual behaviour: when we modify an object, the
modification of the object has to be instantly reflected in the system and the
new state has to be immediately considered in the rest of the computation.
Having the selection static would introduce more errors to the system.

#### Dependencies and Known Issues

The scan method described above is dependent on two factors:

* order in which actuators are evaluated
* order in which the objects are provided to the filter

Let’s consider two actuators A and B evaluated in the same order: first A then
B. If an object does not match predicates of A, matches predicate for B and
actuator B modifies the object in a way that it would match actuator A, the
object is not evaluated again with the actuator A. We will call this _actuator
order error_.

Let’s consider order of objects {o1, o2, … , on} and an actuator that by
evaluating o1 modifies o2 in a way that o3 will not match the actuator’s
predicate (will lose candidacy, will not be visited). If we provide another
order, for example reverse order, then o2 will be visited. We will call this
_object selection order error_.

How the computation sub-steps are ordered must be known fact to the engine
user. The engine might provide different ways of actuator and object ordering
to the computation controller.

The prototype implementation yields objects in the order as provided by the
language dynamic collection structures such as a hash table or a dictionary.
The actuators are evaluated in the same way as they are provided by the model
parser or created programatically.

_Note:_ It might be interesting to further investigate effect of ordering to
the outcome of certain models. For example shuffling objects and/or actuators
every step, shuffling objects for every actuator, ordering objects by their
properties etc.

#### Predicates from Modifiers

In the object selection process, not only predicates should be considered, but
also the modifiers. Certain modifiers might have requirements for the state or
existence of a property they operate on. For example, we can’t `CLEAR` a a
counter which does not exist, or we can’t `BIND` to a slot which is already
bound. Those modifiers impose implicit, hidden predicates that affect the
selection.

## Application of Modifiers

Modifiers from actuators are applied to the objects in the actuator’s
selection.  As mentioned before, the application of a modifier changes the
state of the system and therefore has impact on the remaining non-evaluated
objects and properties within the same step of computation.

## Alternative Computations

The _Sequential scan (of cartesian product) with actuators first_ is one
method of many others. Here are examples of other possible computation methods
that can be implemented using traditional computer architecture. Here are few
examples of serial computation methods:

* _Objects First:_ Similar to the sequential scan with actuator first but we
  visit all potentially affected objects first and loop through actuators
  during object’s visit.
* _Dependency Traversal:_ Start with a full-scan visitation. Once an object’s
  bindings are modified, diverge from the full scan and follow the bindings for
  objects that were not yet visited. At the end of the diverge return back to
  the full scan but skip already visited objects.
* _Random:_ Variation on the sequential scan where either objects are visited
  sequentially but actuators are applied in random order, or objects are
  visited in a random order and actuators are applied sequentially or both
  objects and actuators are visited in a random order.

The methods are yet to be tested to tell how the typical outcome and potential
errors of the computation using such methods are.

### Parallel Computation

Massively parallel computation is the ultimate goal of the system as it closely
mimics the behaviour in the real world. By _massively parralel_ we mean one
processing unit per object per actuator observing the relevant context of the
attached object.

Simplified parallelism can be achieved by  splitting the object graph into
smaller parts, performing partial computations and then consolidating the
results. This is a whole are to be explored as it opens many questions, such
as:

* How to synchronise the computation?
* How to resolve potential modifier-predicate order conflicts?
* How to consolidate conflicting modifications?
* How the consolidation method affects the outcome of the computation?
* Which parameters of the computation configuration affect potential errors of
  the computation and in which way?
