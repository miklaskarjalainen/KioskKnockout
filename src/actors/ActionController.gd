extends Node

const BASIC_PUNCH = preload("res://src/actors/Attacks/BasicPunch.tscn")

@onready var player: Player = get_parent()
@export var anim_controller: AnimationController = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(anim_controller)
	assert(player, "is null")
	assert(player is Player, "is not player")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(player.InputNormal):
		anim_controller.play_action("punch")
		# r_arm.add_child(BASIC_PUNCH.instantiate())
	
