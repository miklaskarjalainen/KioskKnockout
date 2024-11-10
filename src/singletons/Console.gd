extends Control

var commands: Dictionary = {}

var _previous_focus: NodePath = ""
@onready var _output_text: RichTextLabel = $output
@onready var _input_text: LineEdit = $input

func get_commands() -> Dictionary:
	return commands

func toggle_visibility() -> void:
	visible = not visible
	if visible:
		_move_position_to_be_last_child()
		if get_viewport().gui_get_focus_owner() != null:
			_previous_focus = get_viewport().gui_get_focus_owner().get_path()
		_input_text.grab_focus()
	else:
		_input_text.release_focus()
		if _previous_focus:
			var n = get_node_or_null(_previous_focus)
			if n != null:
				n.grab_focus()
			_previous_focus = ""

func message(msg: String, args := []):
	var combined := msg
	for i in args:
		combined += "%s" % i
	combined += "\n"
	_output_text.add_text(combined)

func info(msg: String, args := []):
	_output_text.push_color(Color.LIGHT_SKY_BLUE)
	message(msg, args)
	_output_text.pop()

func warning(msg: String, args := []):
	_output_text.push_color(Color.ORANGE)
	message(msg, args)
	_output_text.pop()

func error(msg: String, args := []):
	_output_text.push_color(Color.RED)
	message(msg, args)
	_output_text.pop()

func clear():
	_output_text.clear()

func add_command(n: String, cmd: Cmd):
	commands[n] = cmd

func _move_position_to_be_last_child() -> void:
	var child_count = get_parent().get_child_count()
	get_parent().move_child(self, child_count - 1)

func _ready() -> void:
	visible = false
	Cmd.initialize_commands()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("kb_toggle_console"):
		toggle_visibility()

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var cmd_args := new_text.split(" ")
	var cmd_name := cmd_args[0]
	cmd_args.remove_at(0)
	_input_text.clear()
	
	if not commands.has(cmd_name):
		error("No command '%s' exists!" % cmd_name)
		return
	
	var arg_count = commands[cmd_name].arg_count
	if cmd_args.size() < arg_count:
		if arg_count == 1:
			error("Command '%s' requires at least one argument!" % [cmd_name])
		else:
			error("Command '%s' requires at least %s arguments!" % [cmd_name, arg_count])
		return
	
	commands[cmd_name].fn.call(cmd_args)
	
