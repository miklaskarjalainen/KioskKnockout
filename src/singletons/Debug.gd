extends Control

@onready var label: Label = $text_renderer

func _ready() -> void:
	if not OS.is_debug_build():
		hide();

func add_line(n: String, v: Variant) -> void:
	label.text += "%s: %s\n" % [n, v]

func _clear() -> void:
	label.text = ""

func _physics_process(delta: float) -> void:
	_clear()
	add_line("Version", Engine.get_version_info()["string"])
	add_line("FPS", Engine.get_frames_per_second())
	add_line("VSync", "enabled" if DisplayServer.window_get_vsync_mode() else "disabled")
	
	if Input.is_action_just_pressed("toggle_debug"):
		visible = not visible
	
	
