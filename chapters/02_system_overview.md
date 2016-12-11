# Virtual Laboratory Overview

The main components of the system and it’s external context are: simulation
engine, object store, controller and collector-observer:

![Engine and related components](images/system-engine)

## Engine

An _engine_ is a component that performs the simulation in an iterative way and
serves as a main control element between the higher level simulation controller
and the simulation state.

There might be multiple kinds of engines with different ways of running the
simulation. Since the simulation might be very method sensitive it is
important to choose the most satisfying engine for a given task.

The common tasks that an engine performs are:

* Instantiate objects from the model concepts.
* Instantiate objects from concepts by request.
* Run a single or several iteration steps.
* Measure the simulation state and forward it for storage or visualisation to
  a _collector_.
* Handle and optionally forward the control actions.

Engine uses _store_ as an object container. The store is responsible for:

* Creation of new objects
* Modification of objects
* Selection of objects based on selector and/or predicates
* Persisting objects and their relationships

## Controller

Controller is an external entity that controls the engine. It might be an
application which direct purpose is the simulation or it might be a system
where the simulation engine serves just as an opaque subsystem. In the first
of the depicted example cases the existence of the engine is exposed to the
human user and the application through which the user interacts with the engine
is a rich extension of the engine that we would call _virtual laboratory_. In
the virtual laboratory the human user is active part of the system. In the
second example case the user interacts with an application which uses the
engine to perform simulation which just provide results for other goals of
the client application. In this case the existence of the engine is hidden from
the user and user is indirect user of the engine. We call this case simply
_application_.

![Examples of system integration](images/system-uses)

We will call _simulation controller_ a program or a person using such program
that can initiate change of the simulation state independently of the internal
behavioural rules of the simulation. In the two mentioned cases, the
simulation controllers can be virtual laboratory and it’s user or the
application. Application’s user is not considered to be a simulation
controller since they have no explicit knowledge of the engine and neither
might have direct control over the simulation.

Controller is also the primary entity that receives _trap_ events from the
engine. Every time a trap or a collection of traps occurs, the simulation
control is interrupted and it is handled to the controller.

## Observer and Collector

Each time a measurement happens the result of the measurement is passed to the
external system called _observer_. The observer receives information about the
measurement event and the measurement data from probes. Typical observer writes
the data to a data store for further analysis. This kind of observer we call
_collector_.

In the embedded use of the engine, the application is both – the controller and
the observer. The application consumes the observed simulation measurements
and transforms them into application product. An example of this use might be
an educational or a game engine that uses Sepro simulation for certain aspects
of the game mechanics.

Another example of simulation observer in a virtual laboratory setting is
where the observer might provide data to an automated decisioning module which
is coupled with the controller. The simulation control might be described by
decision rules. For example alteration of the simulation state based on a
observed value thresholds. This can be used to automate more sophisticated
experiments by applying a rule-based experiment protocol. The setting is
depicted in the following image:

![Automated decisioning](images/system-automated)
