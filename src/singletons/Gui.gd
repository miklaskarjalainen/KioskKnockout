extends Control

var player_1_path: NodePath = ""
var player_2_path: NodePath = ""

@onready var player1_bar: ProgressBar = $container/Player1
@onready var player2_bar: ProgressBar = $container/Player2
@onready var pause_screen: ColorRect = $PauseScreen
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel
@onready var victory_screen: ColorRect = $VictoryScreen


func _update_health_bars() -> void:
	var pl1: Player = get_node_or_null(player_1_path)
	var pl2: Player = get_node_or_null(player_2_path)
	
	if pl1 and pl2:
		player1_bar.value = pl1.Health.current_health
		player2_bar.value = pl2.Health.current_health
	visible = Global.in_game

func _physics_process(delta: float) -> void:
	_update_health_bars()
	timer_label.text = str(ceil(timer.time_left))

func _ready() -> void:
	timer_label.hide()
	pause_screen.hide()
	victory_screen.hide()
	Input.joy_connection_changed.connect(func (device: int, connected: bool):
		if connected:
			return
		elif Global.players_controller_prefix.has(Global.INPUT_PREFIXES[device + 1]):
			get_tree().paused = true
			pause_screen.show()
			Global.set_focus(pause_screen.get_child(0), 1)
	)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ev := event as InputEventKey
		if ev.is_action_pressed("kb_pause") and Global.in_game:
			get_tree().paused = !get_tree().paused
			if get_tree().paused:
				pause_screen.show()
				Global.set_focus(pause_screen.get_child(0), 1)
			else:
				pause_screen.hide()

func _on_continue_btn_pressed() -> void:
	get_tree().paused = false
	pause_screen.hide()

func _on_ps_quit_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("exit")
	pause_screen.hide()

func ko_timer() -> void:
	timer.start(3)
	timer_label.show()
	timer.timeout.connect(
		func() -> void:
			## FIXME: you can still toggle pause menu while
			## the victory screen is shown which toggles the pause state
			get_tree().paused = true
			timer_label.hide()
			victory_screen.show()
			timer.stop()
	)

func _on_vs_quit_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("exit")
	victory_screen.hide()

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("reload")
	victory_screen.hide()
