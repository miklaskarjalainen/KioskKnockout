extends Node
### The idea for the AnimationController is to decide which animations to play.
### For example if no action is taking place it should do the Idle animation
### automatically.
class_name AnimationController

@export var anim: AnimationPlayer = null

# Animation priority list. First animation which is not empty string is played.
# This is just an idea on how to handle this. Never tried it before.
var _animation_list: Array[String] = [
	"",     # [0] action
	"",     # [1] movement
	"idle", # [2] fallback
]

func play_action(anim: String):
	_animation_list[0] = anim

func _ready() -> void:
	assert(anim, "is null")
	anim.animation_finished.connect(_animation_finished)

func _get_target_anim_index() -> int:
	for idx in _animation_list.size():
		if not _animation_list[idx].is_empty():
			return idx
	assert(false, "should never reach")
	return -1

func _get_target_anim() -> String:
	return _animation_list[_get_target_anim_index()]

func _physics_process(delta: float) -> void:
	var t: String = _get_target_anim()
	if not anim.is_playing() or anim.current_animation != t:
		anim.play(t)

func _animation_finished(anim: String):
	var idx: int = _get_target_anim_index()
	if idx == 2:
		return
	
	if _animation_list[idx] == anim:
		_animation_list[idx] = ""
