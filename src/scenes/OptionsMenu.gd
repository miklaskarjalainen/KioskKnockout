extends Control
class_name OptionsMenu

@onready var master_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Percentage
@onready var music_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Percentage
@onready var sfx_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Percentage
@onready var ui_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Percentage
@onready var vsync_state_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/VSync/State
@onready var max_fps_value_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/MaxFPS/Value
@onready var fullscreen_state_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/FullScreen/State


func _ready() -> void:
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/CloseButton.grab_focus()
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Slider.value = AudioManager.master_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Slider.value = AudioManager.music_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Slider.value = AudioManager.sfx_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Slider.value = AudioManager.ui_volume * 100
	if (DisplayServer.window_get_vsync_mode() as int) == 1:
		vsync_state_label.text = "Enabled"
		$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/VSync/CheckButton.button_pressed = true
	else:
		vsync_state_label.text = "Disabled"
		$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/VSync/CheckButton.button_pressed = false
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/MaxFPS/Slider.value = clamp(5, 240, Engine.max_fps)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_state_label.text = "Enabled"
		$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/FullScreen/CheckButton.button_pressed = true
	else:
		fullscreen_state_label.text = "Disabled"
		$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Graphics/FullScreen/CheckButton.button_pressed = false

func _on_close_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/TitleScreen.tscn")

func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioManager.master_volume = value / 100
	AudioManager.update_audio_server()
	master_volume_label.text = "%s%s" % [int(value), "%"]

func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioManager.music_volume = value / 100
	AudioManager.update_audio_server()
	music_volume_label.text = "%s%s" % [int(value), "%"]

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	AudioManager.sfx_volume = value / 100
	AudioManager.update_audio_server()
	sfx_volume_label.text = "%s%s" % [int(value), "%"]

func _on_ui_volume_slider_value_changed(value: float) -> void:
	AudioManager.ui_volume = value / 100
	AudioManager.update_audio_server()
	ui_volume_label.text = "%s%s" % [int(value), "%"]

func _on_vsync_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		vsync_state_label.text = "Enabled"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		vsync_state_label.text = "Disabled"

func _on_max_fps_slider_value_changed(value: float) -> void:
	var _fps: int = int(value)
	var _text: String = str(_fps)
	if int(value) == 9:
		_text = "Unlimited"
		_fps = 0
	max_fps_value_label.text = "%s" % [_text]
	Engine.max_fps = _fps

func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_state_label.text = "Enabled"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_state_label.text = "Disabled"
