extends Node

# Since the attacking player is added to atk's excludes before added to the scene
# Grab the attcker from there. A bit cheesy, but works.
@onready var attacker: Player = get_parent()._excludes[0]

const EXTRA_JUMP_HEIGHT: float = 4.2
const EXTRA_GRAVITY: float = 12.0

var _recovery_phase: bool = false
var _recovery_frames: int = 32

func _ready() -> void:
	attacker.velocity.y = EXTRA_JUMP_HEIGHT

func _physics_process(delta: float) -> void:
	if not _recovery_phase:
		attacker.velocity.y -= EXTRA_GRAVITY * delta
		
		if attacker.is_on_floor():
			_recovery_phase = true
	else:
		_recovery_frames -= 1
		if _recovery_frames <= 0:
			get_parent().queue_free()
		
		
	
