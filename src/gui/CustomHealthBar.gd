extends ProgressBar
class_name CustomHealthBar

const BEGIN_YELLOW_COLOR: int = 50
const BEGIN_RED_COLOR: int = 25

func _ready() -> void:
	theme_type_variation = ""
	value_changed.connect(func(new_hp: int):
		if new_hp <= BEGIN_YELLOW_COLOR:
			theme_type_variation = "ProgressBarYellow"
		if new_hp <= BEGIN_RED_COLOR:
			theme_type_variation = "ProgressBarRed"
		)
