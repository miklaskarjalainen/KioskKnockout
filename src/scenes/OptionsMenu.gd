extends Control
class_name OptionsMenu

@onready var master_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Percentage
@onready var music_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Percentage
@onready var sfx_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Percentage
@onready var ui_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Percentage


func _ready() -> void:
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Slider.value = AudioManager.master_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Slider.value = AudioManager.music_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Slider.value = AudioManager.sfx_volume * 100
	$MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Slider.value = AudioManager.ui_volume * 100

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
