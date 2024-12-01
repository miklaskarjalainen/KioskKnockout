extends Node
class_name GameState

@export var Camera: TargetCamera
@export var Ingame: bool = true

func _ready() -> void:
	Global.in_game = Ingame
	Engine.time_scale = 1.0 if Ingame else 0.65
	
	assert(Camera, "Camera is not assigned")
	for target in Camera.Targets:
		if target is Player:
			target.Health.on_died.connect(func(): _on_player_death(target))
	
	GUI.start_timer()
	if Ingame:
		AudioManager.play("res://assets/sounds/music/Infinite Realities.ogg", AudioManager.Audio_Player.Music)

func _exit_tree() -> void:
	Global.in_game = false
	if Ingame:
		AudioManager.play("res://assets/sounds/music/Generating Worlds.ogg", AudioManager.Audio_Player.Music)

func _on_player_death(player: Player) -> void:
	GUI.ko_timer()
	for target in Camera.Targets:
		if target != player:
			Camera.remove_target(target)
