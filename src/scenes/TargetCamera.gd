extends Camera3D
class_name TargetCamera

@export var Targets: Array[Node3D] = []
@export var MaxZoom: float = 25.0
@export_range(0.1, 16.0) var Smoothing: float = 2.4

@onready var _center_offset := Vector2(global_position.x, global_position.y)
var _initial_distance: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true
	assert(Targets != null and Targets.size(), "Targets is empty")
	_initial_distance = global_position.z

func _vec3_to_vec2(vec: Vector3) -> Vector2:
	return Vector2(vec.x, vec.y)

func _calculate_center() -> Vector2:
	if not Targets:
		return Vector2(0.0, global_position.y)
	
	var point: Vector2
	for target in Targets:
		point += _vec3_to_vec2(target.global_position)
	point /= Targets.size()
	
	return point

func _max_distance_between_targets() -> float:
	assert(Targets.size() == 2, "Only works if there are 2 targets")
	var tx0 := Targets[0].global_position.x
	var tx1 := Targets[1].global_position.x
	return abs(tx0 - tx1)

func _physics_process(delta: float) -> void:
	# X & Y
	var target_camera_pos := Vector3()
	target_camera_pos.x = _calculate_center().x
	target_camera_pos.y = global_position.y
	
	# Z
	var distance := _max_distance_between_targets()
	var MAGIC_NUMBER := 0.035
	target_camera_pos.z = _initial_distance + (distance * distance * MAGIC_NUMBER)
	target_camera_pos.z = clamp(target_camera_pos.z, 0.0, MaxZoom)
	
	# With smoothing
	global_position = lerp(global_position, target_camera_pos, delta * Smoothing)
