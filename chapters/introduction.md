# Aims and Principles of Sepro

Sepro is a method, simulation system and a problem specific language inspired
by biochemical processes for modelling of complex dynamical systems from
conceptual and qualitative perspective.

The system is meant to provide means to model and observe evolution of a
complex system from basic principles which are as free of one's assumptions as
possible. Assumptions we try to liberate the model from are mostly explicit
ordering of events and quantitative properties.

We would like to propose a method and a system that would be used as a basis
for building a simulator that is biological in its nature. The developed method
should serve to model, understand, solve, and convey knowledge about
domain-specific problems of dynamical complex systems.

Our goal is to be able to describe the problem by collection of seemingly
unrelated observed _state change primitives_ which we call _actuators_. They
are simplifications of observed events and observed circumstances of the
events. Examples of over-simplified observations that are similar to a
text-book like descriptions of the events:

* "An influenza virus enters a cell expressing sialic acid by binding of
  hemagglutinin"
* "A thirsty man who drank a glass of water was not thirsty any more"


Preferred is higher number of modelled observations to complexity of the
observations. By reducing assumed complexity we reduces the modelling error or
potential falsification of the model. This helps us to increase trust in the
model and to the outcomes of the simulation.

Similar to order of events in nature, which is given by the state of
environment, not by a predefined sequence of instructions, our system does not
have a way to explicitly describe order of events. Even though it might be
possible to impose order through modelling a state machine, it is not guaranteed
that the order will be preserved due to possibility of interference from other
parts of the simulated system. We assume this as a positive property of the
simulated method.


## Method and System Development

For the development process of the method and the system, we are adhering to
several principles that help us during design decision process. 

* Completeness and clarity of model description
* Minimal set of assumptions
* Iterative simulation and parallel in nature
* No explicit control flow
* Observable and measurable system
* Separation of control environment and internal simulation state

One of the long term aims that we would like to achieve is: _the system and the
model should be translate-able into physical biological or other non-linear and
non-conventional equivalent_. 

The simulation system and method proposed in this document is not final and
might itself evolve as more understanding from the problem domain emerges. See
last chapter for discussion about potential directions.


## Focus on observation

* Emergence of behavioural patterns
* Interactions of behavioural patterns through their effects
* Effects of fluctuations and fluctuation induced behavioural and structural
  novelties
* Evolutionary transformations of information structures

That we are more concerned about the  instabilities as opposed to equilibria.
We rather want to study amplification of fluctuations instead of central
tendencies.
