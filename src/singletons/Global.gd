extends Node

signal OptionsOpened()
signal OptionsClosed()

signal MasterVolumeChanged(new_value: float)
signal MusicVolumeChanged(new_value: float)

var players_controller_prefix: Array[String] = [
	"kb",
	"_0joy"
]

## Recursively finds node with the given name, from a parent node. 
func find_node_or_null(parent: Node, target: String) -> Node:
	for n in parent.get_children():
		if n.name == target:
			return n
		
		var found = find_node_or_null(n, target)
		if found:
			return found
	
	return null
