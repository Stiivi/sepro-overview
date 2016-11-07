# Example

To demonstrate the system we created a simple and somewhat more abstract
problem: create a chain of objects representing chain links using another
object that “wields” two links together. Think of a molecule of a polymer
created by some protein building the polymer from it’s free floating
components.

### The Model

Concepts:
	
	CONCEPT linker
	    TAG ready
	    SLOT left, right
	
	CONCEPT link
	    TAG free
	    SLOT next

The concepts are visualised in the following image:

![Concepts](images/example-linker_objects)

Predicates:

Whenever there is free floating link and liker has a free left slot, then the other object is bound to the linker and will become no longer free. 

	WHERE linker AND NOT BOUND left ON link, free DO
	    BIND left TO other
	    IN other UNSET free
	    SET one
	

If the linker is holding one link and encounters another free link, then the other link is bound to the linker. The linker enters state of owning two links.

	WHERE one ON link, free DO
	    BIND right TO other
	    IN other UNSET free
	    UNSET one
	    SET two

If linker owns two links, then it links the left object to the right and suggests that it might advance.

	WHERE two DO
	    IN this.left BIND next TO this.right
	    UNSET two
	    SET advance

Linker advances to the next link by releasing the left object and passing the right object to the left binding site.

	WHERE advance DO
	    BIND left TO this.right
	    UNSET advance
	    SET cleanup

Make the linker hold only one object.

	WHERE cleanup DO
	    UNBIND right
	    UNSET cleanup
	    SET one

Note that we might combine the `advance` and `cleanup` states, however the atomicity of the modifiers is not well specified yet and the behaviour might be undefined.

The initial world contains 5 links and one linker.

	WORLD main
	    OBJECT link * 5
	    OBJECT linker

### Computation

The order of the actuators does not really matter in this example. Each time we will get the same result just slightly delayed in some cases.

### Result

The result of the computation is depicted in the next image where all the
simulation steps are visualised.

![Result](images/example-result)
