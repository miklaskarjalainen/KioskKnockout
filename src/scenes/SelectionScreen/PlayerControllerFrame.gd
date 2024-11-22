extends Control

var _device: int = -1

func _update_prompt(img_path: String):
	var prompt: RichTextLabel = $leave_prompt
	
	prompt.clear()
	prompt.append_text("[center]Press ")
	prompt.append_text(
		"[img width=32 height=32]%s[/img]" % img_path
	)
	prompt.append_text(" to leave!")
	

func _physics_process(delta: float) -> void:
	# FIXME: this not even supposed to work anywhere else, okay? If ever made to support more controllers this needs to be fixed.
	$player_name.text = "Player %s!" % [
		1 if get_parent().get_children()[0] == self else 2
	]

func set_device(n: int) -> void:
	# Keyboard
	if n == 0:
		$controller_text.texture = load("res://assets/prompts/diagrams/Keyboard_Diagram_Simple.png")
		_update_prompt("res://assets/prompts/diagrams/Keyboard_Esc.png")
		$controller_text.modulate.a = 0.5
	# Controller
	else:
		match Input.get_joy_name(n-1):
			"PS5 Controller":
				$controller_text.texture = load("res://assets/prompts/diagrams/PS5_Diagram_Simple.png")
				_update_prompt("res://assets/prompts/diagrams/PS4_Circle.png")
			"PS4 Controller":
				$controller_text.texture = load("res://assets/prompts/diagrams/PS4_Diagram_Simple.png")
				_update_prompt("res://assets/prompts/diagrams/PS4_Circle.png")
			_: # Generic, use the xbox one diagram.
				$controller_text.texture = load("res://assets/prompts/diagrams/Xbox_Diagram_Simple.png")
				_update_prompt("res://assets/prompts/diagrams/Xbox_B.png")
		
		print(Input.get_joy_name(n-1))
		
	_device = n

func get_device() -> int:
	return _device
