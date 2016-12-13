# Appedix B: Rejected or Postponed Ideas

The ideas listed here were either rejected or postponed for further
re-consideration or re-design.

## Root Object

The _root object_ served as a globally referencable state. From simulation
dynamics perspective it was no different to any other object. The only
difference with other objects was that the root object could be referenced
explicitly in actuators. Objects were able to react with the root object
through binary selectors where one of the selector operands was a root object.

From the original proposal:

> There might be situations where we need to consider a global state in a
> simulation. For that purpose there is one special object that we call _root_.
> It is the only object that can be explicitly globally referenced. Every
> simulation has a root object, event-though it might be unused. Default root
> object is empty, has no properties and no slots.

The idea was rejected. Main reason was that we have to focus on local
interactions.

## Counters

_Counters_ were quantitative properties of a concept. The quantity stored is a
number of instances of countable quality associated with the object. A counter
can be imagined as a container able to hold multiple copies of the same tag.
The only difference is that the _counter_ is a static property of an object.

![Object counters](images/object-counters)

Counters, being static properties can not be dis-associated from neither
associated with an object during run time. At least not in this early
implementation. Impact of this feature requires more research.

Counters can be changed by incrementing or decrementing their values. Counters
can be cleared to be zero and they can be tested whether they are zero.

Counters were temporarily rejected because they can be partially implemented
through existing mechanisms. Whether counters should remain in the model or not
is still open for dicsussion and more research is needed.

### Predicates for Counters

Counters can be tested for having a zero value or be compared against a
constant contained the predicate:

`ZERO` _counter_: is true when the value of _counter_ is 0.

There is no equality operator (`=`) that tests whether a _counter_ is equal to
a constant value. Reason is that the state changes should occur only when there
is “enough of something” or “not yet enough of something”. Given distributed
and complex nature of the simulation, equality comparison might not be
properly evaluated in every desired case. Equality comparator is very sensitive
to the order of evaluation and predicate might miss the exact moment where
equality might be measured. Inequality comparators are more resistant to the
internal evaluation order.

The following two comparison operators are present in the simulation engine
prototype, however they are questionable whether they should exist. They have
some backing in form such as reactions to fixed “quantifiable presence of a
substance” or “quantifiable energy”. However, they can be abused to form an
equality operator and they also increase simulation complexity.

_counter_ `>` _constant_: is true when the value of _counter_ is greater than
_constant_

_couter_ `<` _constant_: is true when the value of _counter_ is less than
_constant_

Their use is preliminarily discouraged.


* `ZERO` _counter_: value of _counter_ is zero
* `>` _value_: _counter_ is greater than a constant _value_
* `<` _value_: _counter_ is less than a constant _value_

### Counter Modifiers

State of the counters can be changed in three ways: increase value, decrease
value or clear the counter – make it zero.

`INC` _counter_: counter ← counter + 1 

`DEC` _counter_: counter ← counter - 1

`CLEAR` _counter_: counter ← 0

Example of counter modifiers:

	DEC energy
	INC health

Counters have no upper bounds. General rule is to maintain relatively small
values in the counters. Implementation a simulation engine might impose upper
bound based on capabilities of the platform the engine is operating on. The
bound should be “large enough” to satisfy most of the modelling needs. Model
creators and simulation engine designers should be aware of the limits and
adapt their strategy accordingly.

Attempt to decrease value of counters where value is zero  results in counter
remaining zero. This is preliminary recommended behaviour in the prototype for
simplicity. This behaviour might change. See developer notes for discussion.

