extends Node

const GRAVITY := 52.0
# 0 = no buffering allowed, 1 = 1 frame, etc... (Physics frames)
const JUMP_BUFFER_FRAMES := 4

@export var player: Player = null

@export var MoveSpeed: float = 3.4
@export var JumpVelocity: float = 8.8
@export var JumpHoldStr: float = 12.5

var _jump_buffer: int = 0

func is_grounded() -> bool:
	return player.is_on_floor()

func _ground_movement(delta: float) -> void:
	# Handle jump.
	if _jump_buffer > -1:
		player.velocity.y = JumpVelocity
		_jump_buffer = -1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis(player.InputLeft, player.InputRight)
	var direction := (player.transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		player.velocity.x = direction.x * MoveSpeed
		player.velocity.z = direction.z * MoveSpeed
	else:
		player.velocity.x = 0.0
		player.velocity.z = 0.0

func _air_movement(delta: float):
	if Input.is_action_pressed(player.InputJump) and player.velocity.y > 5.0:
		player.velocity.y += JumpHoldStr * delta

func _physics_process(delta: float) -> void:
	if _jump_buffer > -1:
		_jump_buffer -= 1
	
	if Input.is_action_just_pressed(player.InputJump):
		_jump_buffer = JUMP_BUFFER_FRAMES
	
	if is_grounded():
		_ground_movement(delta)
	else:
		player.velocity.y -= GRAVITY * delta
		_air_movement(delta)
	
	player.move_and_slide()
