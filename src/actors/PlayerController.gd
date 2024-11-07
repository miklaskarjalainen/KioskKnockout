extends Node

const GRAVITY := 52.0

@export var player: Player = null

@export var MoveSpeed: float = 3.4
@export var JumpVelocity: float = 8.8
@export var JumpHoldStr: float = 12.5

func is_grounded() -> bool:
	return player.is_on_floor()

func _ground_movement(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed(player.InputJump):
		player.velocity.y = JumpVelocity
	
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
	Debug.add_line("is_grounded: ", is_grounded())
	Debug.add_line("velocity: ", player.velocity)
	
	if is_grounded():
		_ground_movement(delta)
	else:
		player.velocity.y -= GRAVITY * delta
		_air_movement(delta)
	
	player.move_and_slide()
