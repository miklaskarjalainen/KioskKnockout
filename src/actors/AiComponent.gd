extends Node
class_name CharacterAI

@export var enabled: bool = true

@onready var player: Player = get_parent()
@onready var opponent: Player = get_parent().Opponent

func dist_to_opp() -> float:
	return abs(player.global_position.x - opponent.global_position.x)

# Get a weighted list of all actions the ai can make.
func _weight_options() -> Dictionary:
	var opts := {
		player.InputLeft   : 1,
		player.InputRight  : 1,
		player.InputUp     : 1,
		player.InputDown   : 0,
		player.InputJump   : 0,
		player.InputNormal : 0,
		player.InputSpecial: 0,
	}
	
	if opponent.Health.is_dead():
		opts[player.InputDown] = 400
		opts[player.InputUp]   = 400
		opts[_last_action]   = 1000
	
	# If opponent is really far, prefer walking towards it.
	if dist_to_opp() > 1.85:
		if player.is_opponent_on_right():
			opts[player.InputRight] += 25
		else:
			opts[player.InputLeft] += 25
		
	elif not opponent.Health.is_dead():
		# Otherwise prefer making an attack.
		opts[player.InputDown] = 10
		opts[player.InputNormal] = 5
		opts[player.InputSpecial] = 5
		
		# Further away, do a kick.
		if dist_to_opp() > 1.65:
			opts[player.InputSpecial] += 35
		else:
			opts[player.InputNormal] += 35
		
		# Try countering from air (Uppercut)
		if not opponent.is_on_floor():
			if player.Action._button_buffer.size() > 0 and not player.Action._button_buffer[0] == "up":
				opts[player.InputUp] += 69
			else:
				opts[player.InputNormal] += 69
	
	if not player.is_on_floor():
		opts[player.InputSpecial] += 90
	
	# Prefer using the same action as previous frame.
	if not _last_action.is_empty():
		opts[_last_action] += 150
	
	# Prefer blocking an attack, escpecially continueing if already began
	if dist_to_opp() < 2.0 and opponent.Action.is_performing_action():
		opts[player.InputDown] += 80
		if _last_action == player.InputDown:
			opts[player.InputDown] += 1000
	
	
	return opts

# Picks randomly 1 key with the biggest weight
func _pick_weighted(dict: Dictionary):
	var weight_sum: int = 0
	for w in dict.values():
		weight_sum += w
	var result = randi_range(0, weight_sum)
	for v in dict.keys():
		if result <= dict[v]:
			return v
		result -= dict[v]
	return null

var _last_action: String = ""
# Press an action, release the action pressed previous frame.
func _press(ac: String):
	if _last_action == ac:
		return
	
	if not _last_action.is_empty():
		Input.action_release(_last_action)
	Input.action_press(ac)
	_last_action = ac

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	var ac = _pick_weighted(_weight_options())
	if ac:
		_press(ac)

func _exit_tree() -> void:
	if _last_action.is_empty():
		return
	Input.action_release(_last_action)
