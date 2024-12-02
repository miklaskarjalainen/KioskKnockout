extends Node

const INPUT_PREFIXES: Array[String] = [
	"kb",
	"_0joy",
	"_1joy",
	"_2joy",
	"_3joy",
	"_ai",
]

var players_controller_prefix: Array[String] = [
	"kb",
	"_0joy"
]
var _main_scene_tree: SceneTree = null
var in_game: bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

## Grab focus of a nth child of a node
func set_focus(parent: Node, index: int) -> void:
	if parent:
		var child = parent.get_child(index);
		if child:
			child.grab_focus()

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
	elif get_tree().paused:
		Console.error("Could not perform scene change while the game is paused.")
		return
	_main_scene_tree.change_scene_to_file(fpath)
	Console.info("Scene changed to: '%s'." % fpath)

func reload_main_scene():
	_main_scene_tree.reload_current_scene()
	Console.info("Scene reloaded.")
