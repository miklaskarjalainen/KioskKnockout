extends Node

var _main_scene_tree: SceneTree = null
var in_game: bool = false

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

func change_main_scene_to(fpath: String):
	if not _main_scene_tree:
		Console.error("Could not perform scene change, because the Global.main_scene is null. Maybe because a scene was run directly and not through the titlescreen.")
		return
	_main_scene_tree.change_scene_to_file(fpath)

func reload_main_scene():
	_main_scene_tree.reload_current_scene()
