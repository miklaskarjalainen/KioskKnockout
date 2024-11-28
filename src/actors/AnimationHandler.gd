extends Node
## The idea for the AnimationController is to decide which animations to play.
## For example if no action is taking place it should do the Idle animation
## automatically.
class_name AnimationController

@export var anim: AnimationPlayer = null
@export var actions: ActionController = null
@export var controller: PlayerController = null

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
	controller.on_jump.connect(func():
		anim.stop()
		anim.play("jump")
	)

func _physics_process(delta: float) -> void:
	Debug.add_line("anim", anim.current_animation)
	
	if controller.is_hitstun():
		anim.play("hitstun")
		return
	if anim.current_animation == "jump" and anim.is_playing():
		return
	
	var target_anim = ""
	if not actions.player.is_on_floor():
		target_anim = "inair"
	elif actions.player.velocity.x > 0.0:
		if actions.player.is_opponent_on_right():
			target_anim = "walk_forwards"
		else:
			target_anim = "walk_backwards"
	elif actions.player.velocity.x < 0.0:
		if actions.player.is_opponent_on_right():
			target_anim = "walk_backwards"
		else:
			target_anim = "walk_forwards"
	else:
		target_anim = "idle"
	
	if not actions.is_performing_action() and anim.current_animation != target_anim:
		
		anim.play(target_anim)
