extends Node
class_name PlayerController

signal on_jump()

const GRAVITY := 52.0
# 0 = no buffering allowed, 1 = 1 frame, etc... (Physics frames)
const JUMP_BUFFER_FRAMES := 4
const BACK_PEDAL_MULTIPLIER := 0.8

@export var player: Player = null
@export var actions: ActionController = null
@export var block: BlockController = null

@export var MoveSpeed: float = 3.4
@export var JumpVelocity: float = 13.2
@export var JumpHoldStr: float = 18.5

var is_blocking := true

var _hitstun_timer   : int = 0 # How many frames left.
var _knockback_timer : int = 0 # How many frames left.
var _knockback_amount := Vector2(0,0)

var _jump_buffer: int = 0

func set_hitstun(duration: int):
	_hitstun_timer = duration

func is_hitstun() -> bool:
	return _hitstun_timer > 0

func apply_knockback(amount: Vector2, duration: int):
	var dir = -1 if player.is_opponent_on_right() else 1
	_knockback_amount = amount
	_knockback_amount.x *= dir
	_knockback_timer = duration

func is_grounded() -> bool:
	return player.is_on_floor()

func _ground_movement(delta: float) -> void:
	# Handle jump.
	if _jump_buffer > -1:
		player.velocity.y = JumpVelocity
		_jump_buffer = -1
		on_jump.emit()
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis(player.InputLeft, player.InputRight)
	if input_dir:
		var back_pedaling: bool = player.is_opponent_on_right() == (input_dir < 0.0)
		if back_pedaling:
			player.velocity.x = input_dir * (MoveSpeed * BACK_PEDAL_MULTIPLIER)
		else:
			player.velocity.x = input_dir * MoveSpeed

func _air_movement(delta: float):
	if Input.is_action_pressed(player.InputJump) and player.velocity.y > 5.0:
		player.velocity.y += JumpHoldStr * delta

func _physics_process(delta: float) -> void:
	# Moving on the Z-axis is porhibited.
	player.velocity.z = 0.0
	player.global_position.z = 0.0
	
	# Timers
	if _jump_buffer > -1:
		_jump_buffer -= 1
	if _knockback_timer > 0:
		_knockback_timer -= 1
		if _knockback_timer == 0:
			_knockback_amount = Vector2(0,0)
	if _hitstun_timer > 0:
		_hitstun_timer -= 1
		Debug.add_line("STUN", _hitstun_timer)
	
	if player.is_on_floor():
		player.velocity.x = 0.0
	
	if _knockback_timer > 0:
		# What to do if under the effect of a knockbock
		player.velocity.x = _knockback_amount.x
		player.velocity.y = _knockback_amount.y
	elif is_hitstun():
		_do_gravity(delta)
	elif actions.is_performing_action():
		_do_gravity(delta)
	elif not block.can_move():
		_do_gravity(delta)
	else:
		# Normal movement
		_do_gravity(delta)
		if Input.is_action_just_pressed(player.InputJump):
			_jump_buffer = JUMP_BUFFER_FRAMES
		if is_grounded():
			_ground_movement(delta)
		else:
			_air_movement(delta)
	
	player.move_and_slide()

func _do_gravity(delta: float) -> void:
	player.velocity.y -= GRAVITY * delta

func _ready():
	assert(player, "is null")
	assert(actions, "is null")
