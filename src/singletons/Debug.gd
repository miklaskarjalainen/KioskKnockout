extends Control

@onready var label: Label = $text_renderer


func add_line(n: String, v: Variant) -> void:
	label.text += "%s: %s\n" % [n, v]

func _clear() -> void:
	label.text = ""

func _physics_process(delta: float) -> void:
	_clear()
	add_line("Version", Engine.get_version_info()["string"])
	add_line("FPS", Engine.get_frames_per_second())
	add_line("VSync", "enabled" if DisplayServer.window_get_vsync_mode() else "disabled")
