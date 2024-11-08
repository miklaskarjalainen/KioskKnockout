extends Control

@export var player_1_path: NodePath = ""
@export var player_2_path: NodePath = ""

@onready var player1_bar: ProgressBar = $Player1
@onready var player2_bar: ProgressBar = $Player2

func _physics_process(delta: float) -> void:
	var pl1: Player = get_node_or_null(player_1_path)
	var pl2: Player = get_node_or_null(player_2_path)
	
	if pl1:
		player1_bar.value = pl1.Health.current_health
	if pl2:
		player2_bar.value = pl2.Health.current_health
	
