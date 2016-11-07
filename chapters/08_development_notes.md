# Development Notes

## Model Development Notes

**Structures**: The _structures_ are currently non-recursive entities. They can
be composed only from direct concept instances. It is open for debate whether
recursive structures should be allowed or not, since their instantiation
increases complexity of the store and/or the engine. For now, the
recommendation is that the higher level modelling tool would handle the
complexity and then just generate these primitive structures.

**Predicates, selectors and modifiers** as stand-alone elements: It simplifies
human readability, reduces redundancy, has no effect on computability.

**Inclusion**: Currently the models have to be self-contained, they can’t
include other models. Inclusion increases complexity of the compiler and, most
importantly, requires symbol conflict resolution. Sepro does not consider
namespaces yet. This functionality should be delegated to the model builder for
now.

**Measures** are used to observe either concrete counter property of a concrete
object or an aggregation of properties. There is no plan to include generic
arithmetic expressions to the observer specification as has significant impact
on the simplicity of the compiler and the implementation of the engine.
Potential feature to be included in the system is aggregation by grouping.

**Root abuse**: It might be tempting to use the _root_ object and it’s slot as
a a dictionary and extend the pool of global named objects. The practice of
extensive set of predicates testing in root object’s slots (`WHERE ROOT IN slot
...`) is highly discouraged.

## Concept Development Notes

**Slots**: The terms _slot_ is used from the
[Self]((http://www.selflanguage.org) programming language where it represents a
property of an object: either a value or an object reference. We are using it
only as object reference.

**Static Slots**: In the current implementation, every concept and therefore
it’s instances – objects – have static number of slots. Possibility of having
dynamic number of slots requires further research of modelling necessity and
computation complexity.

**Namespaces**: There are no namespaces in the early implementation. Namespaces
are useful, however their implementation have to be done with respect to the
user and model writer, should not be ambiguous and should be easy to implement
by compilers.

**Inheritance**: There is no inheritance of concepts at the moment.
Implementation of inheritance requires a bit more research to explore the
possibilities. The major reasons for omission of concept inheritance are:
undefined rules of inheritance, instantiation complexity at the side of the
engine. The instantiation complexity can be resolved by model pre-compilation,
where the recursive structure will be unwound. 

**Flip**: It is questionable whether it might be beneficial but genuine at the
same time to have operation _flip_ on a _tag_ which would work like a switch.
It will_set_ a tag when tag is not present and _unset_ a tag when tag is
present.

**Future of tags**: there might be system for tag relationship and conceptual
inheritance.

**Counter Bounds**: Potentially the counters might have an upper bound or be
cyclic. More research of such property in the nature  and it’s impact on
computation complexity is needed.

## Actuator Development Notes

**Greater and Less Predicate** – justification of the comparison predicates in
the system is questionable. Since there are examples in the nature where we
might assume that the observed behaviour can be similar to a value comparison,
for now we can consider the comparison predicates to be primitive enough
(insignificant assumption burden). We keep them in the early implementation.

**Tag Flip** We have not decided yet whether there should be a modifier that
“flips” a tag, that is, sets a tag if it is not set and unsets a tag if it is
set. The non-atomic modification can be implemented using twi separate
actuators. More research is needed for justification of the atomic `FLIP` tag
modifier.

**Decrease Zero Counter**: In the future modifier-based predicates might be
introduced which might result in the opposite behaviour: actuator not being
activated.

**Bind to Bound, Unbind Unbound**: To avoid confusion, this behaviour might be
changed in a way that binding-based modifiers will have binding-based internal
predicates associated with them. The actuator will very likely not be activated
when trying to bind to already taken slot as well as trying to unbind a slot
that has no binding. Slot has to be freed before a new binding is created and
the action can’t be made atomic.

**Multiple Modifiers on Same Parameter**: The prototype implementation allows
multiple modifiers to operate on the same parameter, such as setting/unsetting
the same tag, increasing/decreasing or zeroing the same counter, binding two
different objects on the same slot. Result of such action is currently
undefined and it is computation engine specific.In the future this situation
might be disallowed in a way that such model would not be considered valid.

## Engine

**Time**: In the future time might not be considered local and different parts
of the simulation might have different time scales. However, the implications
of the non-global time is not to be explored in the near future.
