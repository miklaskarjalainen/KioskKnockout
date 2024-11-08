extends Node3D
class_name AttackHurtbox

const HITBOX_MATERIAL: StandardMaterial3D = preload("res://assets/dev/dev_solid_red.tres")
static var visible_hitboxes: bool = false

@export_range(0, 100) var dmg: int = 0
@export_range(0, 5.0, 0.1) var duration := 0.0 

var _excludes: Array[Node3D] = []

func add_exclude(node: Node3D):
	_excludes.push_back(node)

func _create_mesh_for_collision_shape(shape: CollisionShape3D):
	var mesh: Mesh = null
	
	if shape.shape is BoxShape3D:
		mesh = BoxMesh.new()
		mesh.size = (shape.shape as BoxShape3D).size
	else:
		Console.error("Could not create hitbox mesh, invalid shape type.")
		return
	
	var node := CSGMesh3D.new()
	node.mesh = mesh
	node.material = HITBOX_MATERIAL
	shape.add_child.call_deferred(node)

func _ready():
	if AttackHurtbox.visible_hitboxes:
		for shape in get_children():
			_create_mesh_for_collision_shape(shape)
	
	await get_tree().create_timer(duration).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# TODO: do dmg
	pass
