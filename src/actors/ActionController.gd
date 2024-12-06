extends Node
class_name ActionController

const ACTION_ERASE_FRAMES: int = 12

## Action name should be the same as the Animation name
signal action_started(action_name: String, anim_spd: float)
signal action_ended()

@onready var player: Player = get_parent()
@export var anim_controller: AnimationController = null
@export var ground_cast: RayCast3D = null
@export var block: BlockController = null
@export var health: HealthComponent = null

@onready var pos_rhand = Global.find_node_or_null(player, "pos_rhand")
@onready var pos_lhand = Global.find_node_or_null(player, "pos_lhand")
@onready var pos_rleg = Global.find_node_or_null(player, "pos_rleg")
@onready var pos_lleg = Global.find_node_or_null(player, "pos_lleg")

var _current_actions: Array[Node3D] = []

var _button_erase: int = -1
var _button_buffer := []
var _performing_action := false

func is_performing_action() -> bool:
	return _performing_action 

func _ready() -> void:
	assert(anim_controller)
	assert(player, "is null")
	assert(health, "is null")
	assert(player is Player, "is not player")
	assert(pos_rhand, "is null")
	assert(pos_lhand, "is null")
	
	health.on_damaged.connect(func (_dmg: int):
		for c in _current_actions:
			c.queue_free()
		_current_actions.clear()
		)
	
	action_started.connect(func(_ac: String, _spd: float): _performing_action = true)
	action_ended.connect(func(): _performing_action = false)

func _perform_action(action_path: String) -> bool: 
	if action_path.is_empty():
		return false
	
	var atk: AttackHurtbox = load(action_path).instantiate()
	action_started.emit(atk.play_anim, atk.anim_speed)
	_current_actions.push_front(atk)
	atk.tree_exiting.connect(func():
		if _current_actions.has(atk):
			_current_actions.erase(atk)
		action_ended.emit()
	)
	atk.add_exclude(player)
	
	match atk.hitbox_location:
		0:
			pos_rhand.add_child(atk)
		1:
			pos_rleg.add_child(atk)
		2:
			pos_lhand.add_child(atk)
		3:
			pos_lleg.add_child(atk)
		_:
			Console.error("Invalid hitbox location")
	return true

# Try to match action buffer to an action.
func _submit_action() -> bool:
	if _button_buffer.size() == 0:
		return false
	if is_performing_action():
		return false
	if player.Health.is_dead():
		return false
	if not block.can_move():
		return false
	
	var buf = _button_buffer
	
	# TODO: dashes
	if buf.size() >= 2:
		if buf[0] == "left" and buf[1] == "left":
			Console.warning("Dashes not implemented")
			return false
		elif buf[0] == "right" and buf[1] == "right":
			Console.warning("Dashes not implemented")
			return false
	
	var normal = "res://src/actors/Attacks/BasicPunch.tscn"
	var special = "res://src/actors/Attacks/KarateKick.tscn"
	
	if buf.size() >= 2 and buf[1] == "up":
		normal = "res://src/actors/Attacks/UpperCut.tscn"
		special = "res://src/actors/Attacks/GroinKick.tscn"
	
	if not player.is_on_floor():
		normal = ""
		special = ""
	
	if not ground_cast.is_colliding():
		special = "res://src/actors/Attacks/JumpSpecial.tscn"
	
	match buf[0]:
		"normal":
			return _perform_action(normal)
		"special":
			return _perform_action(special)
		_:
			return false

# Adds a action to buffer
func _push_action(str: String):
	_button_buffer.push_front(str)
	_button_erase = ACTION_ERASE_FRAMES
	
	while _button_buffer.size() > 3:
		_button_buffer.pop_back()

func _physics_process(delta: float) -> void:
	Debug.add_line("btn_buffer", _button_buffer)
	Debug.add_line("buffer_erase", _button_erase)
	_handle_action_inputs()

func _handle_action_inputs() -> void:
	if Input.is_action_just_pressed(player.InputLeft):
		_push_action("left")
	if Input.is_action_just_pressed(player.InputRight):
		_push_action("right")
	if Input.is_action_just_pressed(player.InputUp):
		_push_action("up")
	if Input.is_action_just_pressed(player.InputDown):
		_push_action("down")
	if Input.is_action_just_pressed(player.InputNormal):
		_push_action("normal")
	if Input.is_action_just_pressed(player.InputSpecial):
		_push_action("special")
	
	if _button_buffer.size() > 0:
		if _button_buffer.front() == "special" or _button_buffer.front() == "normal":
			if _submit_action():
				_button_buffer.clear()
				_button_erase = -1
	
	if _button_erase >= 0:
		_button_erase -= 1
		if _button_erase == -1:
			_button_buffer.clear()
