extends Control

var player_1_path: NodePath = ""
var player_2_path: NodePath = ""

@onready var player1_bar: ProgressBar = $container/Player1
@onready var player2_bar: ProgressBar = $container/Player2
@onready var pause_screen: ColorRect = $PauseScreen


func _update_health_bars() -> void:
	var pl1: Player = get_node_or_null(player_1_path)
	var pl2: Player = get_node_or_null(player_2_path)
	
	if pl1:
		player1_bar.value = pl1.Health.current_health
	if pl2:
		player2_bar.value = pl2.Health.current_health

func _physics_process(delta: float) -> void:
	_update_health_bars()

func _ready() -> void:
	pause_screen.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ev := event as InputEventKey
		if ev.is_action_pressed("kb_pause") and Global.in_game:
			get_tree().paused = !get_tree().paused
			if get_tree().paused:
				pause_screen.show()
			else:
				pause_screen.hide()

func _on_continue_btn_pressed() -> void:
	get_tree().paused = false
	pause_screen.hide()

func _on_quit_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("exit")
	pause_screen.hide()
