extends HSlider
class_name SfxHSlider

@export var focus_enter_ui_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"
@export var slider_changed_ui_sound_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"


func _ready() -> void:
	if focus_enter_ui_sound_path != null:
		mouse_entered.connect(func (): grab_focus())
		focus_entered.connect(func (): AudioManager.play(focus_enter_ui_sound_path, AudioManager.Audio_Player.UI))
	if slider_changed_ui_sound_path != null:
		value_changed.connect(func (_v: float): AudioManager.play(slider_changed_ui_sound_path, AudioManager.Audio_Player.UI))
