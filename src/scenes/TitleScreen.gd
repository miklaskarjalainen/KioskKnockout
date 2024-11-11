extends Control;

@onready var buttons_h_box: Container = Global.find_node_or_null(self, "ButtonContainer")

func _ready() -> void:
	set_focus()
	Global._main_scene_tree = get_tree()

func set_focus() -> void:
	if buttons_h_box:
		var button: Button = buttons_h_box.get_child(0);
		if button is Button:
			button.grab_focus();

func _on_play_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/SelectionScreen.tscn")

func _on_options_button_pressed() -> void:
	Global.change_main_scene_to("res://src/scenes/OptionsMenu.tscn")

func _on_about_button_pressed() -> void:
	Console.warning("Not Implemented")
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit();
