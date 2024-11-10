extends CharacterBody3D
class_name Player

const MODEL_ROTATION_SPEED := 8.4

@onready var Model: Node3D = $player_model
@onready var Health: HealthComponent = $HealthComponent
@onready var Controller: PlayerController = $PlayerController

@export var PlayerIndex := 0 # 0 is first player, 1 is second player
@export var Opponent: Player = null

@export var InputLeft := "kb_left"
@export var InputRight := "kb_right"
@export var InputDown := "kb_down"
@export var InputUp := "kb_up"
@export var InputJump := "kb_jump"
@export var InputNormal := "kb_normal_action"

func _ready():
	assert(Opponent, "Opponent not assigned")
	assert(Model, "Model not assigned")
	Model.rotation.y = get_model_target_rotation()
	
	if PlayerIndex == 0:
		GUI.player_1_path = get_path()
	elif PlayerIndex == 1:
		GUI.player_2_path = get_path()

func get_model_target_rotation() -> float:
	var opponent_on_right := is_opponent_on_right()
	return PI if opponent_on_right else 0.0

func is_opponent_on_right() -> bool:
	return Opponent.global_position.x > global_position.x

func _physics_process(delta: float) -> void:
	var target_rot = get_model_target_rotation()
	Model.rotation.y = lerp(Model.rotation.y, target_rot, delta * MODEL_ROTATION_SPEED)
	
	Debug.add_line("health", Health.current_health)
