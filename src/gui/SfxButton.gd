extends Button
class_name SfxButton

@export var focus_enter_ui_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"
@export var button_pressed_ui_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"

func _ready() -> void:
	if focus_enter_ui_sound_path != null:
		mouse_entered.connect(func (): 
			if not disabled:
				grab_focus()
			)
		focus_entered.connect(func (): AudioManager.play(focus_enter_ui_sound_path, AudioManager.Audio_Player.UI))
	if button_pressed_ui_sound_path != null:
		pressed.connect(func (): AudioManager.play(button_pressed_ui_sound_path, AudioManager.Audio_Player.UI))
