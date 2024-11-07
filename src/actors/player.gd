extends CharacterBody3D

@export var InputLeft := "kb_left"
@export var InputRight := "kb_right"
@export var InputDown := "kb_down"
@export var InputUp := "kb_up"
@export var InputJump := "kb_jump"

@export var Speed: float = 5.0
@export var JumpVelocity: float = 4.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(InputJump) and is_on_floor():
		velocity.y = JumpVelocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis(InputLeft, InputRight)
	var direction := (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * Speed
		velocity.z = direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)

	move_and_slide()
