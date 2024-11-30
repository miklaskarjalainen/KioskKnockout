extends Node
class_name BlockController

@onready var player: Player = get_parent()
@export var action: ActionController = null
@export var mesh: MeshInstance3D = null

const BLOCK_STARTUP : int = 3
const BLOCK_RECOVERY: int = 8
const BLOCK_HEALTH: int = 60
const RECHARGE_RATE: int = 8
const DISCHARGE_RATE: int = 5
const SHIELD_BREAK_STUN: int = 60

var _is_blocking: bool = false
var _block_health: int = BLOCK_HEALTH

var _startup_timer: int = 0
var _recovery_timer: int = 0
var _recharge_timer: int = 0
var _discharge_timer: int = 0

func damage(dmg: int):
	_block_health -= dmg
	if _block_health <= 0:
		player.Controller.set_hitstun(SHIELD_BREAK_STUN)
		_block_health = 1

func is_blocking() -> bool:
	return _is_blocking

func can_move() -> bool:
	return _startup_timer == 0 and _recovery_timer == 0 and not _is_blocking

func _set_block_state(state: bool):
	_is_blocking = state
	mesh.visible = state

func _ready() -> void:
	assert(mesh)
	assert(action)
	
	mesh.visible = false

func _discharge_shield():
	if not is_blocking():
		return
	
	_discharge_timer += 1
	if _discharge_timer >= DISCHARGE_RATE:
		_discharge_timer -= RECHARGE_RATE
		damage(1)

func _recharge_shield():
	if _block_health >= BLOCK_HEALTH or is_blocking():
		return
	
	_recharge_timer += 1
	if _recharge_timer >= RECHARGE_RATE:
		_recharge_timer -= RECHARGE_RATE
		_block_health += 1

func _physics_process(delta: float) -> void:
	_recharge_shield()
	_discharge_shield()
	
	if Input.is_action_pressed(player.InputDown) and player.is_on_floor() and _recovery_timer == 0 and _startup_timer == 0 and not is_blocking():
		_startup_timer = BLOCK_STARTUP
		_recovery_timer = 0
	if not Input.is_action_pressed(player.InputDown) and _recovery_timer == 0 and is_blocking():
		_recovery_timer = BLOCK_RECOVERY
		_startup_timer = 0
		_set_block_state(false)
	
	if _startup_timer > 0:
		_startup_timer -= 1
		if _startup_timer == 0 and Input.is_action_pressed(player.InputDown):
			_set_block_state(true)
	
	if _recovery_timer > 0:
		_recovery_timer -= 1
	
	
	mesh.scale = Vector3(1.0,1.0,1.0) / (BLOCK_HEALTH/float(_block_health))
