extends Node

@export var enabled: bool = true

@onready var player: Player = get_parent()
@onready var opponent: Player = get_parent().Opponent

func dist_to_opp() -> float:
	return abs(player.global_position.x - opponent.global_position.x)

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
		opts[player.InputDown] = 15
		opts[player.InputNormal] = 25
		opts[player.InputSpecial] = 25
	if not _last_action.is_empty():
		opts[_last_action] += 100
	
	if dist_to_opp() < 2.0 and opponent.Action.is_performing_action():
		opts[player.InputDown] += 80
	
	return opts

func _pick_weighted(dict: Dictionary):
	var weight_sum: int = 0
	for w in dict.values():
		weight_sum += w
	var result = randi_range(0, weight_sum)
	Debug.add_line("weight", weight_sum)
	Debug.add_line("rsult", result)
	for v in dict.keys():
		if result <= dict[v]:
			return v
		result -= dict[v]
	return null

var _last_action: String = ""
func _press(ac: String):
	print(ac)
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