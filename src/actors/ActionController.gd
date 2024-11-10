extends Node
class_name ActionController

const BASIC_PUNCH = preload("res://src/actors/Attacks/BasicPunch.tscn")

## Action name should be the same as the Animation name
signal action_started(action_name: String)
signal action_ended()

@onready var player: Player = get_parent()
@export var anim_controller: AnimationController = null

@onready var pos_rhand = Global.find_node_or_null(player, "pos_rhand")
@onready var pos_lhand = Global.find_node_or_null(player, "pos_lhand")

var _performing_action := false

func _ready() -> void:
	assert(anim_controller)
	assert(player, "is null")
	assert(player is Player, "is not player")
	assert(pos_rhand, "is null")
	assert(pos_lhand, "is null")
	
	action_started.connect(func(_ac: String): _performing_action = true)
	action_ended.connect(func(): _performing_action = false)
	

func _physics_process(delta: float) -> void:
	if _performing_action:
		return
	
	if Input.is_action_just_pressed(player.InputNormal):
		var atk: AttackHurtbox = BASIC_PUNCH.instantiate()
		
		Console.message("perform action: %s" % atk.play_anim)
		action_started.emit(atk.play_anim)
		atk.tree_exiting.connect(func():
			action_ended.emit()
		)
		
		atk.add_exclude(player)
		pos_rhand.add_child(atk)
