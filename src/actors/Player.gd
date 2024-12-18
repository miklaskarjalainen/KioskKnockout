extends CharacterBody3D
class_name Player

const MODEL_ROTATION_SPEED := 8.4

@onready var Action: ActionController = $ActionController
@onready var Model: Node3D = $player_model
@onready var ModelSkin: SkinChanger = $SkinChanger
@onready var Health: HealthComponent = $HealthComponent
@onready var Controller: PlayerController = $PlayerController
@onready var Block: BlockController = $BlockController
@onready var AI: CharacterAI = $AiComponent

@export var PlayerIndex := 0 # 0 is first player, 1 is second player
@export var Opponent: Player = null
@export var Invincible := false

@onready var InputLeft := "%s_left" % Global.players_controller_prefix[PlayerIndex]
@onready var InputRight := "%s_right" % Global.players_controller_prefix[PlayerIndex]
@onready var InputDown := "%s_down" % Global.players_controller_prefix[PlayerIndex]
@onready var InputUp := "%s_up" % Global.players_controller_prefix[PlayerIndex]
@onready var InputJump := "%s_jump" % Global.players_controller_prefix[PlayerIndex]
@onready var InputNormal := "%s_normal_action" % Global.players_controller_prefix[PlayerIndex]
@onready var InputSpecial := "%s_special_action" % Global.players_controller_prefix[PlayerIndex]


func _ready():
	assert(Opponent, "Opponent not assigned")
	assert(Model, "Model not assigned")
	assert(ModelSkin, "is null")
	Model.rotation.y = get_model_target_rotation()
	
	if Global.players_controller_prefix[PlayerIndex] == "_ai":
		AI.enabled = true
	
	if PlayerIndex == 0:
		GUI.player_1_path = get_path()
		ModelSkin.set_skin_texture("res://assets/characters/P1_texture.png")
	elif PlayerIndex == 1:
		GUI.player_2_path = get_path()
		ModelSkin.set_skin_texture("res://assets/characters/P2_texture.png")

func get_model_target_rotation() -> float:
	var opponent_on_right := is_opponent_on_right()
	return PI if opponent_on_right else 0.0

func is_opponent_on_right() -> bool:
	return Opponent.global_position.x > global_position.x

func damage(dmg: int, knockback_amount: Vector2, knockback_duration: int, hitstun: int):
	if Invincible:
		dmg = 0
	
	if Block.is_blocking():
		AudioManager.play("res://assets/sounds/sfx/block1.ogg", AudioManager.Audio_Player.SFX)
		
		Block.damage(dmg)
		# 10% of damage and  atleast 1.
		dmg = max(dmg * 0.10, 1)
		if Invincible:
			dmg = 0
		
		knockback_amount *= 0.10
		Health.damage(dmg)
		Controller.apply_knockback(knockback_amount, knockback_duration)
		return
	
	AudioManager.play("res://assets/sounds/sfx/hit1.ogg", AudioManager.Audio_Player.SFX)
	
	if dmg >= randi_range(7, 18):
		AudioManager.play("res://assets/sounds/sfx/voice_hit1.ogg", AudioManager.Audio_Player.SFX)
	
	Health.damage(dmg)
	Controller.apply_knockback(knockback_amount, knockback_duration) 
	Controller.set_hitstun(hitstun)

func _physics_process(delta: float) -> void:
	if is_on_floor() and not Health.is_dead():
		var target_rot = get_model_target_rotation()
		Model.rotation.y = lerp(Model.rotation.y, target_rot, delta * MODEL_ROTATION_SPEED)
	
	if Health.is_dead() and not is_on_floor():
		Model.rotation.y = lerp(Model.rotation.y, Model.rotation.y+180, delta * delta * MODEL_ROTATION_SPEED)
	
	Debug.add_line("health", Health.current_health)
