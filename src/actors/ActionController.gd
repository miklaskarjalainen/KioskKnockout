extends Node

const BASIC_PUNCH = preload("res://src/actors/Attacks/BasicPunch.tscn")

@onready var player: Player = get_parent()
@onready var r_arm: Node3D = player.get_node("player_model/Node/Torso/RArm2/RElbow/cube")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(player, "is null")
	assert(r_arm, "is null")
	assert(player is Player, "is not player")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(player.InputNormal):
		player.get_node("player_model/AnimationPlayer").play("punch")
		r_arm.add_child(BASIC_PUNCH.instantiate())
	
