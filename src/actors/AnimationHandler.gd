extends Node
## The idea for the AnimationController is to decide which animations to play.
## For example if no action is taking place it should do the Idle animation
## automatically.
class_name AnimationController

const ANIM_BLEND: float = 0.25

@export var anim: AnimationPlayer = null
@export var actions: ActionController = null
@export var controller: PlayerController = null
@export var health: HealthComponent = null
@export var block: BlockController = null
var _action_anim: String = ""

func play_action(p_anim: String, p_spd: float):
	anim.play(p_anim, ANIM_BLEND, p_spd)

func _ready() -> void:
	assert(anim, "is null")
	assert(actions, "is null")
	assert(controller, "is null")
	assert(block, "is null")
	
	actions.action_started.connect(func(action: String, spd: float):
		_action_anim = action
		play_action(action, spd)
	)
	anim.animation_finished.connect(func(anim_name: String):
		if anim_name == _action_anim:
			anim.play("idle", ANIM_BLEND)
	)
	
	controller.on_jump.connect(func():
		anim.play("jump", ANIM_BLEND)
	)
	health.on_damaged.connect(func():
		anim.play("getting_hit", ANIM_BLEND)
	)
	health.on_died.connect(func():
		anim.play("Defeat", ANIM_BLEND)
	)

func _physics_process(delta: float) -> void:
	Debug.add_line("anim", anim.current_animation)
	
	if health.current_health <= 0:
		return
	
	if controller.is_hitstun():
		if anim.current_animation != "getting_hit":
			anim.play("hitstun", ANIM_BLEND)
		return
	if anim.current_animation == "jump" and anim.is_playing():
		return
	
	var target_anim = ""
	if block.is_blocking():
		target_anim = "Block"
	elif not actions.player.is_on_floor():
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
