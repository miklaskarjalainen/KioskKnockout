extends Control;

@onready var buttons_h_box: Container = Global.find_node_or_null(self, "ButtonContainer")

func _ready() -> void:
	$MarginContainer/VBoxContainer/ButtonContainer/PlayButton.grab_focus()
	Global._main_scene_tree = get_tree()

func _on_play_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/SelectionScreen.tscn")

func _on_options_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/OptionsMenu.tscn")

func _on_about_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/AboutScreen.tscn")

func _on_exit_button_pressed() -> void:
	print("quitting")
	get_tree().quit()
