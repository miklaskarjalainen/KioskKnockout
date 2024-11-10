extends Control

@onready var player1_inputs: ItemList = $player1_inputs
@onready var player2_inputs: ItemList = $player2_inputs

const INPUTS_TYPES: Array[String] = [
	"kb_",
	"_0joy_",
	"_1joy_",
	"_2joy_",
	"_3joy_",
]

## 0, is the index into the INPUTS_TYPES array.
## 0: {
##   "controller_index": 0,
##   "name": "PS5 Controller"
## }
var _connected_joypads: Dictionary = {}
var _input_choice: Array[int] = []

func _update_lists() -> void:
	for key in _connected_joypads:
		player1_inputs.add_item(_connected_joypads[key]["name"])
		player2_inputs.add_item(_connected_joypads[key]["name"])

func _fetch_controller_types():
	_connected_joypads[0] = {
		"controller_index": -1,
		"name": "Keyboard"
	}
	
	for i in Input.get_connected_joypads():
		# Controllers only supported up to 4 at a time.
		if i >= 4:
			break
		
		_connected_joypads[i+1] = {
			"controller_index": i,
			"name": Input.get_joy_name(i)
		}

func _ready():
	_fetch_controller_types()
	_update_lists()

func _pl_1_ready_pressed() -> void:
	if player1_inputs.get_selected_items().is_empty():
		return
	
	var selection: int = player1_inputs.get_selected_items()[0]
	player2_inputs.set_item_disabled(selection, true)

func _pl_2_ready_pressed() -> void:
	if player2_inputs.get_selected_items().is_empty():
		return
	
	var selection: int = player2_inputs.get_selected_items()[0]
	player1_inputs.set_item_disabled(selection, true)
