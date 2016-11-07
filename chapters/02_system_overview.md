# System Overview

The main components of the system and it’s external context are: computation
engine, object store, controller and logger-observer:

![Engine and related components](images/system-engine)

## Engine

An _engine_ performs the computation in an iterative way and serves as a main
control element between the higher level computation controller  and the
computation state.

There might be multiple kinds of engines with different ways of running the
computation. Since the computation might be very method sensitive it is
important to choose the most satisfying engine for a given task.

The common tasks that an engine performs are:

* Instantiate objects from the model concepts.
* Instantiate objects from concepts by request.
* Run a single or several iteration steps.
* Measure the computation state and forward it for storage or visualisation to
  a _logger_.
* Handle and optionally forward the control actions.

Engine uses _store_ as an object container. The store is responsible for:

* Creation of new objects
* Modification of objects
* Selection of objects based on selector and/or predicates
* Persisting objects and their relationships

## Controller

Controller is an external entity that controls the engine. It might be an
application which direct purpose is the computation or it might be a system
where the computation engine serves just as an opaque subsystem. In the first
of the depicted example cases the existence of the engine is exposed to the
human user and the application through which the user interacts with the engine
is a rich extension of the engine that we would call _virtual laboratory_. In
the virtual laboratory the human user is active part of the system. In the
second example case the user interacts with an application which uses the
engine to perform computations which just provide results for other goals of
the client application. In this case the existence of the engine is hidden from
the user and user is indirect user of the engine. We call this case simply
_application_.

![Examples of system integration](images/system-uses)

We will call _computation controller_ a program or a person using such program
that can initiate change of the computation state independently of the internal
behavioural rules of the computation. In the two mentioned cases, the
computation controllers can be virtual laboratory and it’s user or the
application. Application’s user is not considered to be a computation
controller since they have no explicit knowledge of the engine and neither
might have direct control over the computation.

Controller is also the primary entity that receives _trap_ events from the
engine. Every time a trap or a collection of traps occurs, the computation
control is interrupted and it is handled to the controller.

## Observer and Logger

Each time a measurement happens the result of the measurement is passed to the
external system called _observer_. The observer receives information about the
measurement event and the measurement data from probes. Typical observer writes
the data to a data store for further analysis. This kind of observer we call
_logger_.

In the embedded use of the engine, the application is both – the controller and
the observer. The application consumes the observed computation measurements
and transforms them into application product. An example of this use might be
an educational or a game engine that uses Sepro computation for certain aspects
of the game mechanics.

Another example of computation observer in a virtual laboratory setting is
where the observer might provide data to an automated decisioning module which
is coupled with the controller. The computation control might be described by
decision rules. For example alteration of the computation state based on a
observed value thresholds. This can be used to automate more sophisticated
experiments by applying a rule-based experiment protocol. The setting is
depicted in the following image:

![Automated decisioning](images/system-automated)
