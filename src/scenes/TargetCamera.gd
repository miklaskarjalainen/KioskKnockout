extends Camera3D
class_name TargetCamera

@export var Targets: Array[Node3D] = []
@export var MaxZoom: float = 40.0
@export_range(0.1, 1.0) var MaxMoveSpeed: float = 0.5
@export_range(0.1, 0.4) var Smoothing: float = 0.3


@onready var _center_offset := Vector2(global_position.x, global_position.y)
var _initial_distance: float = 0.0
var _initial_proportion: float = 0.0
var _viewport_rect := Rect2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true
	assert(Targets != null and Targets.size(), "Targets is empty")
	_viewport_rect = get_viewport().get_visible_rect()
	
	get_viewport().size_changed.connect(func():
		_initial_proportion = 0
	)

var _move_tween := Tween.new()

func _process(delta: float) -> void:
	var target_camera_position: Vector3 = _calculate_position(_calculate_unprojected_rect())
	Console.info("%s" % target_camera_position)
	global_position = lerp(global_position, target_camera_position, delta * 16)

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

func _calculate_unprojected_rect() -> Rect2:
	var rect := Rect2(unproject_position(Targets[0].global_position), Vector2())
	for index in Targets.size():
		if index == 0:
			continue
		rect = rect.expand(unproject_position(Targets[index].global_position))
	return rect

func _calculate_position(unprojected_rect: Rect2) -> Vector3:
	var center: Vector2 = _calculate_center()
	var view_rect_ratio: float = unprojected_rect.size.x / _viewport_rect.size.x
	if _initial_proportion == 0:
		_initial_proportion = view_rect_ratio
	if _initial_distance == 0:
		_initial_distance = global_position.distance_to(Vector3(center.x, global_position.y, 0))
	
	# FIXME: The jitter is caused by this. MoveSpeed is making the z go back and fourth.
	var move_speed: float = MaxMoveSpeed
	
	if view_rect_ratio < _initial_proportion:
		move_speed *= -1
	var z_pos = lerp(global_position.z, global_position.z + move_speed, Smoothing)
	Console.info("%s" % z_pos)
	return Vector3(center.x, global_position.y, clamp(z_pos, _initial_distance, MaxZoom))




















pass
