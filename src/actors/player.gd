extends CharacterBody3D
class_name Player

const MODEL_ROTATION_SPEED := 8.4

@onready var Model: Node3D = $player_model

@export var Opponent: Player = null	

@export var InputLeft := "kb_left"
@export var InputRight := "kb_right"
@export var InputDown := "kb_down"
@export var InputUp := "kb_up"
@export var InputJump := "kb_jump"

func _ready():
	assert(Opponent, "Opponent not assigned")
	assert(Model, "Model not assigned")
	Model.rotation.y = get_model_target_rotation()

func get_model_target_rotation() -> float:
	var opponent_on_right := is_opponent_on_right()
	return PI if opponent_on_right else 0.0

func is_opponent_on_right() -> bool:
	return Opponent.global_position.x > global_position.x

func _physics_process(delta: float) -> void:
	var target_rot = get_model_target_rotation()
	Model.rotation.y = lerp(Model.rotation.y, target_rot, delta * MODEL_ROTATION_SPEED)
