extends Node

@onready var player: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player, "is null")
	assert(player is Player, "is not player")


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed(player.InputNormal):
		player.get_node("player_model/AnimationPlayer").play("punch")
	
