extends Button
class_name SfxButton

@export var hover_sfx_path: String = "res://assets/sounds/sfx/sfx_hover.ogg"


func _play_hover():
	if disabled:
		return
	AudioManager.play(hover_sfx_path, AudioManager.Audio_Player.SFX)
	grab_focus()

func _ready() -> void:
	if hover_sfx_path != null:
		mouse_entered.connect(_play_hover)
		focus_entered.connect(_play_hover)
