extends Area3D
class_name AttackHurtbox

const HITBOX_MATERIAL: StandardMaterial3D = preload("res://assets/dev/dev_solid_red.tres")
static var visible_hitboxes: bool = false

@export_category("Frame Data")
@export_range(0, 0.25, 0.01)  var stop_on_hit: float = 0.0 ## How many second to stop the engine for if hit is registered
@export_range(0, 60) var startup  : int = 0 ## How many frames until the attack becomes active
@export_range(0, 60) var active   : int = 0 ## How many frames the attack can do damage
@export_range(0, 60) var recovery : int = 0 ## How many frames until the character can move. (After active frames)
@export_range(0, 60) var hitstun  : int = 0 ## How many frames the target will be stun if hit, should be greater or equal to knockback_duration. (For now atleast).
@export_range(0, 60) var blockstun: int = 0 ## How many frames the target will be stun if blocked
@export_category("Damage")
@export_range(0, 100) var min_dmg: int = 0
@export_range(0, 100) var max_dmg: int = 0
@export var knockback_amount := Vector2(0,0)
@export_range(0, 30) var knockback_duration: int = 0 ## Frames
@export var play_anim: String = "punch"

var _existed: int = 0 # How many frames this attack has existed.
var _excludes: Array[Node3D] = []

func add_exclude(node: Node3D):
	_excludes.push_back(node)

func _ready():
	_disable_hitbox()
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	Console.info(str(_delta))
	
	_existed += 1
	
	if _existed == startup:
		_enable_hitbox()	
	
	var after_startup = _existed - startup
	if after_startup == active:
		_disable_hitbox()
	
	var after_active = after_startup - active
	if after_active == recovery:
		queue_free()

func _disable_hitbox():
	for shape in get_children():
		if not (shape is CollisionShape3D):
			continue
		(shape as CollisionShape3D).visible = false
		(shape as CollisionShape3D).disabled = true

func _enable_hitbox():
	for shape in get_children():
		if not (shape is CollisionShape3D):
			continue
		(shape as CollisionShape3D).visible = true
		(shape as CollisionShape3D).disabled = false
	
		# Add visible meshes
		if AttackHurtbox.visible_hitboxes:
			_create_mesh_for_collision_shape(shape)

func _on_body_entered(body: Node3D):
	if not (body is Player):
		return
	if _excludes.has(body):
		return
	
	_excludes.push_back(body)
	var dmg: int = randi_range(min_dmg, max_dmg)
	(body as Player).damage(
		dmg,
		knockback_amount,
		knockback_duration,
		hitstun
	)
	Console.message("Did %s dmg to %s" % [dmg, body.name])
	
	if stop_on_hit == 0.0:
		return
	
	get_tree().create_timer(stop_on_hit)\
	.timeout\
	.connect(func():
		get_tree().paused = false
	)
	get_tree().paused = true

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
