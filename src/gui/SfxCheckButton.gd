extends CheckButton
class_name SfxCheckButton

@export var focus_enter_ui_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"
@export var button_toggled_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"

func _ready() -> void:
	if focus_enter_ui_sound_path != null:
		mouse_entered.connect(func (): 
			if not disabled:
				grab_focus()
			)
		focus_entered.connect(func (): AudioManager.play(focus_enter_ui_sound_path, AudioManager.Audio_Player.UI))
	if button_toggled_sound_path != null:
		toggled.connect(func (_b: bool): AudioManager.play(button_toggled_sound_path, AudioManager.Audio_Player.UI))
