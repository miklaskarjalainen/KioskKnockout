extends Control;

@onready var buttons_h_box = %ButtonsHBox;

func _ready() -> void:
	if buttons_h_box:
		var button: Button = buttons_h_box.get_child(0);
		if button is Button:
			button.grab_focus();

func _on_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.

func _on_about_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit();
