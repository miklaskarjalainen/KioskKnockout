extends HBoxContainer
class_name PlayerFrameContainer

@export var frame_scene: PackedScene = null 

## 0 - Keyboard, 1 - Controller, 2 - Controller 2
func add_player(device: int):
	var instance = frame_scene.instantiate()
	add_child(instance, true)
	instance.set_device(device)

func remove_player(device: int):
	for c in get_children():
		if c.get_device() == device:
			c.queue_free()
