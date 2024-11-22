extends Node
class_name GameState

@export var Camera: TargetCamera

func _ready() -> void:
	Global.in_game = true
	assert(Camera, "Camera is not assigned")
	for target in Camera.Targets:
		if target is Player:
			target.Health.on_died.connect(func(): _on_player_death(target))

func _exit_tree() -> void:
	Global.in_game = false

func _on_player_death(player: Player) -> void:
	GUI.ko_timer()
	for target in Camera.Targets:
		if target != player:
			Camera.remove_target(target)
