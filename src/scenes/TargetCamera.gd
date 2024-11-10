extends Camera3D
class_name TargetCamera

const MAGIC_NUMBER: float = 0.035

@export var Targets: Array[Node3D] = []
@export var MaxZoom: float = 25.0
@export_range(0.1, 16.0) var Smoothing: float = 2.4
@export_enum("Set Y", "Follow Y") var CameraMode: String = "Set Y"
@export var Offset: Vector2 = Vector2(0, 2.33)

var _initial_distance: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.in_game = true
	top_level = true
	assert(Targets != null and Targets.size(), "Targets is empty")
	_initial_distance = global_position.z

func _exit_tree() -> void:
	Global.in_game = false

func _vec3_to_vec2(vec: Vector3) -> Vector2:
	return Vector2(vec.x, vec.y)

func _calculate_center() -> Vector2:
	var point: Vector2
	for target in Targets:
		point += _vec3_to_vec2(target.global_position)
	point /= Targets.size()
	
	return point

func _max_distance_between_targets() -> float:
	var least_x: float
	var most_x: float
	for target in Targets:
		if target.global_position.x < least_x:
			least_x = target.global_position.x
		if target.global_position.x > most_x:
			most_x = target.global_position.x
	
	return abs(least_x - most_x)

func _physics_process(delta: float) -> void:
	# X & Y
	var target_camera_pos := Vector3()
	var center: Vector2 = _calculate_center() + Offset
	target_camera_pos.x = center.x
	match CameraMode:
		"Set Y":
			target_camera_pos.y = global_position.y
		"Follow Y":
			target_camera_pos.y = center.y
	
	# Z
	var distance := _max_distance_between_targets()
	target_camera_pos.z = _initial_distance + (distance * distance * MAGIC_NUMBER)
	target_camera_pos.z = clamp(target_camera_pos.z, 0.0, MaxZoom)
	
	# With smoothing
	global_position = lerp(global_position, target_camera_pos, delta * Smoothing)
