extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/CloseButton.grab_focus()

func _on_close_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/TitleScreen.tscn")
