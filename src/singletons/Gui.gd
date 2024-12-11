extends Control

var player_1_path: NodePath = ""
var player_2_path: NodePath = ""

@onready var player1_bar: ProgressBar = $container/Player1
@onready var player2_bar: ProgressBar = $container/Player2
@onready var pause_screen: ColorRect = $PauseScreen
@onready var timer_label: Label = $TimerLabel
@onready var victory_screen: ColorRect = $VictoryScreen

var _game_over: bool = true

func _update_health_bars() -> void:
	var pl1: Player = get_node_or_null(player_1_path)
	var pl2: Player = get_node_or_null(player_2_path)
	
	if pl1 and pl2:
		player1_bar.value = pl1.Health.current_health
		player2_bar.value = pl2.Health.current_health
	visible = Global.in_game

func _physics_process(delta: float) -> void:
	_update_health_bars()

func _ready() -> void:
	timer_label.hide()
	pause_screen.hide()
	victory_screen.hide()
	Input.joy_connection_changed.connect(func (device: int, connected: bool):
		if connected or not Global.in_game:
			return
		elif Global.players_controller_prefix.has(Global.INPUT_PREFIXES[device + 1]):
			get_tree().paused = true
			pause_screen.show()
			$PauseScreen/VBoxContainer/ContinueBtn.grab_focus()
	)

func _input(event: InputEvent) -> void:
	_handle_pause(event, "kb_pause")
	_handle_pause(event, "joy_pause")

func _handle_pause(event: InputEvent, action: String) -> void:
	if event.is_action_pressed(action) and Global.in_game and not _game_over:
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			pause_screen.show()
			$PauseScreen/VBoxContainer/ContinueBtn.grab_focus()
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
	_game_over = true
	Engine.time_scale = 0.5
	
	timer_label.show()
	timer_label.text = "3"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	timer_label.text = "2"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	timer_label.text = "1"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	
	Engine.time_scale = 1.0
	
	get_tree().paused = true
	timer_label.hide()
	victory_screen.show()
	$VictoryScreen/RestartBtn.grab_focus()

func start_timer() -> void:
	if not Global.in_game:
		return
	get_tree().paused = true
	Engine.time_scale = 0.5
	
	timer_label.show()
	timer_label.text = "3"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	timer_label.text = "2"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	timer_label.text = "1"
	await get_tree().create_timer(1.0 * Engine.time_scale).timeout
	timer_label.text = "Fight!"
	Engine.time_scale = 1.0
	get_tree().paused = false
	_game_over = false
	
	await get_tree().create_timer(0.5 * Engine.time_scale).timeout
	timer_label.hide()

func _on_vs_quit_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("exit")
	victory_screen.hide()

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	Console.excute_cmd("reload")
	victory_screen.hide()
