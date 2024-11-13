extends Control

var commands: Dictionary = {}

var _command_history: Array[String] = []
var _command_position: int = -1

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
	
	# Iterate through the command history.
	if Input.is_action_just_pressed("ui_up"):
		if _command_history.size() > (_command_position + 1):
			_command_position += 1
			_input_text.text = _command_history[_command_position]
		_input_text.caret_column = _input_text.text.length()
	if Input.is_action_just_pressed("ui_down"):
		_command_position = max(_command_position-1, -1)
		if _command_position >= 0:
			_input_text.text = _command_history[_command_position]
			_input_text.caret_column = _input_text.text.length()
		elif _command_position == -1:
			_input_text.text = ""
			_input_text.caret_column = 0

func excute_cmd(cmd: String, args: Array[String] = []) -> bool:
	if not commands.has(cmd):
		error("No command '%s' exists!" % cmd)
		return false
	
	var arg_count = commands[cmd].arg_count
	if args.size() < arg_count:
		if arg_count == 1:
			error("Command '%s' requires at least one argument!" % [cmd])
		else:
			error("Command '%s' requires at least %s arguments!" % [cmd, arg_count])
		return false
	
	commands[cmd].fn.call(args)
	return true

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var cmd_args := new_text.split(" ")
	var cmd_name := cmd_args[0]
	cmd_args.remove_at(0)
	_input_text.clear()
	
	excute_cmd(cmd_name, cmd_args)
	
	_command_history.push_back(new_text)
	_command_position = -1
	
