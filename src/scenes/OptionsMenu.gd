extends Control
class_name OptionsMenu


func _on_close_button_pressed() -> void:
	Global.OptionsClosed.emit()

@onready var master_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Master/Percentage
func _on_master_volume_slider_value_changed(value: float) -> void:
	Global.MasterVolumeChanged.emit(value)
	master_volume_label.text = "%s%s" % [int(value), "%"]

@onready var music_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/Music/Percentage
func _on_music_volume_slider_value_changed(value: float) -> void:
	Global.MusicVolumeChanged.emit(value)
	music_volume_label.text = "%s%s" % [int(value), "%"]

@onready var sfx_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/SFX/Percentage
func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume_label.text = "%s%s" % [int(value), "%"]

@onready var ui_volume_label: Label = $MarginContainer/VBoxContainer/MarginContainer2/TabContainer/Audio/UI/Percentage
func _on_ui_volume_slider_value_changed(value: float) -> void:
	ui_volume_label.text = "%s%s" % [int(value), "%"]
