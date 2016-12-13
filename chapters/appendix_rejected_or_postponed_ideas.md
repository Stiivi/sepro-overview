# Appedix B: Rejected or Postponed Ideas

The ideas listed here were either rejected or postponed for further
re-consideration or re-design.

## Root Object

The _root object_ served as a globally referencable state. From simulation
dynamics perspective it was no different to any other object. The only
difference with other objects was that the root object could be referenced
explicitly in actuators. Objects were able to react with the root objectthrough
binary selectors where one of the selector operands was a root object.

The idea was rather rejected than postponed. Main reason was focus on local
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


