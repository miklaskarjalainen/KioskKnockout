extends Node
## The idea for the AnimationController is to decide which animations to play.
## For example if no action is taking place it should do the Idle animation
## automatically.
class_name AnimationController

@export var anim: AnimationPlayer = null
@export var actions: ActionController = null
@export var controller: PlayerController = null
var low_priority_anim: String = "idle"

func stop_action():
	anim.stop()

func play_action(p_anim: String):
	anim.stop()
	anim.play(p_anim)

func _ready() -> void:
	assert(anim, "is null")
	assert(actions, "is null")
	assert(controller, "is null")
	actions.action_started.connect(func(action: String):
		play_action(action)
	)
	actions.action_ended.connect(stop_action)

func _physics_process(delta: float) -> void:
	if controller.is_hitstun():
		anim.play("hitstun")
		return
	
	if not actions.is_performing_action() and anim.current_animation != low_priority_anim:
		anim.play(low_priority_anim)
