extends Node
## The idea for the AnimationController is to decide which animations to play.
## For example if no action is taking place it should do the Idle animation
## automatically.
class_name AnimationController

const ANIM_BLEND: float = 0.15

@export var anim: AnimationPlayer = null
@export var actions: ActionController = null
@export var controller: PlayerController = null
@export var health: HealthComponent = null

func play_action(p_anim: String, p_spd: float):
	#anim.stop()
	anim.play(p_anim, ANIM_BLEND, p_spd)

func _ready() -> void:
	assert(anim, "is null")
	assert(actions, "is null")
	assert(controller, "is null")
	actions.action_started.connect(func(action: String, spd: float):
		play_action(action, spd)
	)
	controller.on_jump.connect(func():
		#anim.stop()
		anim.play("jump", ANIM_BLEND)
	)
	health.on_died.connect(func():
		#anim.stop()
		anim.play("Defeat", ANIM_BLEND)
	)

func _physics_process(delta: float) -> void:
	Debug.add_line("anim", anim.current_animation)
	
	if health.current_health <= 0:
		return
	
	if controller.is_hitstun():
		anim.play("getting_hit", ANIM_BLEND)
		return
	if anim.current_animation == "jump" and anim.is_playing():
		return
	
	var target_anim = ""
	if not actions.player.is_on_floor():
		target_anim = "inair"
	elif actions.player.velocity.x > 0.0:
		if actions.player.is_opponent_on_right():
			target_anim = "Walking_forward2"
		else:
			target_anim = "walk_backwards"
	elif actions.player.velocity.x < 0.0:
		if actions.player.is_opponent_on_right():
			target_anim = "walk_backwards"
		else:
			target_anim = "Walking_forward2"
	else:
		target_anim = "idle"
	
	if not actions.is_performing_action() and anim.current_animation != target_anim:
		anim.play(target_anim, ANIM_BLEND)
