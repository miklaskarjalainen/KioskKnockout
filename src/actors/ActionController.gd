extends Node

const BASIC_PUNCH = preload("res://src/actors/Attacks/BasicPunch.tscn")

@onready var player: Player = get_parent()
@export var anim_controller: AnimationController = null

@onready var pos_rhand = Global.find_node_or_null(player, "pos_rhand")
@onready var pos_lhand = Global.find_node_or_null(player, "pos_lhand")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(anim_controller)
	assert(player, "is null")
	assert(player is Player, "is not player")
	assert(pos_rhand, "is null")
	assert(pos_lhand, "is null")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(player.InputNormal):
		anim_controller.play_action("punch")
		pos_rhand.add_child(BASIC_PUNCH.instantiate())
