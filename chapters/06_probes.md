## Measures and Probes

Data for quantitative analysis of the simulation is captured through _probing_
process. _Probes_ are entities that measure a single property of a target
object or aggregate multiple properties of a specified group of objects.
_Measures_ are definitions of the probes.

### Probing and Measures

Single-target probes are attached to a specific object and object’s property.
They report the quantity held by the counter or a boolean value representing
presence/lack of a tag or a binding. Example of a single target measure
attached to object #123:

	MEASURE my_health = health IN 123

Aggregate objects compute an aggregate of measures over all objects or over a
group of objects specified by a set of predicates. Example of an aggregate
probe:

	MEASURE open_count = COUNT WHERE open
	MEASURE average_hungry_health = AVG(health) WHERE ZERO food

Probing happens once after initialisation of the simulation and then after
every step is finished. Every probe is evaluated and the probed value is sent
to the collector associated with the engine.

The _collector_ is an object responsible for storing or delegating probed values.
Typical collector would store values in a file, either as one probe per file or as
multiple probes per file. The collector can also be used to feed the data to the
controller to provide real-time visualisation of the state of the system.

Implementors of collectors must take into account that the number of probes might
change during the simulation, based on the controller’s interests. Therefore
it is recommended the logging format to be flexible or at least the logging
store adaptable for such change. 

Example of collectors:

* CSV file collector: write values to locally stored CSV files
* database table collector: insert values to a table
* network port collector: send values through a network
* controller feedback

The last example of the collectors: _controller feedback_ might be used in the
controller for more sophisticated triggers. For example stopping the
simulation or altering the state when an aggregate value passes certain
threshold. The mechanism is out of control of the engine and is completely up
to the controller.

### Graph Snapshots

Similarly, after every step the collector gets the opportunity to capture a
snapshot of the simulation structure and store it in an appropriate format that
can represent an oriented graph. For example, after every step a collector can
dump a graph in a `graphviz` format for further post-processing into images.
Graph snapshots can also be used by the controller to perform real-time
structure visualisation.
