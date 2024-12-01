extends Node

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
	
	# If opponent is really far, prefer walking towards it.
	if dist_to_opp() > 1.6:
		opts[player.InputDown] = 0
		opts[player.InputNormal] = 0
		opts[player.InputSpecial] = 0
		opts[player.InputUp] = 5
		if player.is_opponent_on_right():
			opts[player.InputRight] += 25
		else:
			opts[player.InputLeft] += 25
	else:
		# Otherwise prefer making an attack.
		opts[player.InputDown] = 15
		opts[player.InputNormal] = 25
		opts[player.InputSpecial] = 25
	
	# Prefer using the same action as previous frame.
	if not _last_action.is_empty():
		opts[_last_action] += 100
	
	# Prefer blocking an attack
	if dist_to_opp() < 2.0 and opponent.Action.is_performing_action():
		opts[player.InputDown] += 80
	
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
