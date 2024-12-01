extends Control

@export var player_container: PlayerFrameContainer = null

const MIN_PLAYER_COUNT: int = 1
const MAX_PLAYER_COUNT: int = 2

var _players: Array[String] = []

func _ready():
	_update_play_button()

func _add_player(device: int):
	if device >= Global.INPUT_PREFIXES.size():
		Console.error("Tried to add a control type which is overbounds! (%s)" % device)
		return
	if _players.size() >= MAX_PLAYER_COUNT:
		return
	
	if not _players.has(Global.INPUT_PREFIXES[device]):
		_players.push_back(Global.INPUT_PREFIXES[device])
		player_container.add_player(device)
	
	_update_play_button()

func _remove_player(device: int):
	if device >= Global.INPUT_PREFIXES.size():
		Console.error("Tried to remove a control type which is overbounds! (%s)" % device)
		return
	
	player_container.remove_player(device)
	_players = _players.filter(func(n: String): return n != Global.INPUT_PREFIXES[device])
	_update_play_button()

func _update_play_button():
	$play.disabled = _players.size() < MIN_PLAYER_COUNT

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var ev := event as InputEventKey
		if ev.physical_keycode == KEY_ESCAPE:
			_remove_player(0)
		else:
			_add_player(0)
	elif event is InputEventJoypadButton:
		var ev := event as InputEventJoypadButton
		var device := ev.device+1
		
		if ev.button_index == JOY_BUTTON_B:
			_remove_player(device)
		else:
			_add_player(device)

func _on_play_pressed() -> void:
	if _players.size() == 1:
		_players.push_back("_ai")
		Console.info("AI enabled")
	Global.players_controller_prefix = _players
	Global.change_main_scene_to("res://src/scenes/Arena1.tscn")


func _on_back_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/TitleScreen.tscn")
