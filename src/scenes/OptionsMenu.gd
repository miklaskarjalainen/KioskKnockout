extends Control
class_name OptionsMenu


func _on_close_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/TitleScreen.tscn")

@onready var master_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Percentage
func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_label.text = "%s%s" % [int(value), "%"]

@onready var music_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Percentage
func _on_music_volume_slider_value_changed(value: float) -> void:
	music_volume_label.text = "%s%s" % [int(value), "%"]

@onready var sfx_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Percentage
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = "%s%s" % [int(value), "%"]

@onready var ui_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Percentage
func _on_ui_volume_slider_value_changed(value: float) -> void:
	ui_volume_label.text = "%s%s" % [int(value), "%"]
