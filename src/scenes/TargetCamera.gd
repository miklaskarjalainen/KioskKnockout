extends Camera3D
class_name TargetCamera

@export var Targets: Array[Node3D] = []
@export var MaxZoom := 50.0
@export_range(0.1, 1.0) var MoveSpeed := 0.5
@export_range(0.1, 0.4) var Smoothing := 0.3


@onready var _center_offset := Vector2(global_position.x, global_position.y)
var _initial_distance := 0.0
var _initial_proportion := 0.0
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
	var target_z := _calculate_position(_calculate_targets_rect(), _calculate_unprojected_rect())
	global_position.z = lerp(global_position.z, target_z, delta * 16)

func _vec3_to_vec2(vec: Vector3) -> Vector2:
	return Vector2(vec.x, vec.y)

func _calculate_unprojected_rect() -> Rect2:
	var rect := Rect2(unproject_position(Targets[0].global_position), Vector2())
	for index in Targets.size():
		if index == 0:
			continue
		rect = rect.expand(unproject_position(Targets[index].global_position))
	return rect

func _calculate_targets_rect() -> Rect2:
	var rect := Rect2(_vec3_to_vec2(Targets[0].global_position), Vector2())
	for index in Targets.size():
		if index == 0:
			continue
		rect = rect.expand(_vec3_to_vec2(Targets[index].global_position))
	return rect

func _calc_center(rect: Rect2) -> Vector2:
	return Vector2(rect.position.x + rect.size.x / 2, rect.position.y + rect.size.y / 2)

func _calculate_position(rect: Rect2, unprojected_rect: Rect2) -> float:
	var center := _calc_center(rect)
	if _initial_proportion == 0:
		_initial_proportion = unprojected_rect.size.x / _viewport_rect.size.x
	if _initial_distance == 0:
		_initial_distance = global_position.distance_to(Targets[0].global_position)
	
	var z_pos := global_position.z
	# FIXME: The jitter is caused by this. MoveSpeed is making the z go back and fourth.
	if unprojected_rect.size.x / _viewport_rect.size.x > _initial_proportion:
		z_pos = global_position.z + MoveSpeed
	elif unprojected_rect.size.x / _viewport_rect.size.x < _initial_proportion:
		z_pos = global_position.z - MoveSpeed
	return clamp(z_pos, _initial_distance, MaxZoom)
