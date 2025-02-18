extends Node

var is_player_controllable: bool = true
var is_pausable: bool = true
var is_playing_cutscene: bool = false
var spectator_mode: bool = false
var is_on_dialogue: bool = true

var state: Dictionary = {
	"death_count" : 0, 
	"codex_collected" : 0, 
	"dash_orbs" : 0
}


var global_dict: Dictionary = {}
var default_global_dict: Dictionary = {}

const GLOBAL_VAR = preload("res://global_var.json")
const CONDITIONS = "conditions"
const STATE = "state"


func _ready():
	# Load the JSON file of global variable
	global_dict = load_json_resource(GLOBAL_VAR)
	default_global_dict = global_dict.duplicate(true)
	
	if not global_dict.is_empty():
		print("GLOBAL : " + str(global_dict))
		print(global_dict.get("is_player_controllable", "YOU SUCKS"))
		print(global_dict["conditions"]["is_player_controllable"])



# ------ GLOBAL VARIABLE FUNCTIONS ------

func get_value(key):
	if state.has(key):
		return state[key]
	else:
		printerr("There is no key called :", key)


func set_state(key, value) -> void:
	state[key] = value


func decrease_value(key) -> void:
	state[key] = state[key] - 1


func increase_value(key) -> void:
	state[key] = state[key] + 1



# Get the condition from global variable, returns TRUE or FALSE
func get_global_condition(key: String) -> bool:
	if get_availability_from_dict(global_dict, CONDITIONS, key):
		return global_dict[CONDITIONS][key]
	
	return false


# Set the condition from global variable, input only TRUE or FALSE
func set_global_condition(key: String, value: bool) -> void:
	if get_availability_from_dict(global_dict, CONDITIONS, key):
		global_dict[CONDITIONS][key] = value


# Get the state from global variable, returns number(integer)
func get_global_state(key: String) -> int:
	if get_availability_from_dict(global_dict, STATE, key):
		return global_dict[STATE][key]
	
	return 0


# Set the state from global variable, input only numbers
func set_global_state(key: String, value: int) -> void:
	if get_availability_from_dict(global_dict, STATE, key):
		global_dict[STATE][key] = value


# Increase the state from global variable
func increase_global_state(key: String, step: int) -> void:
	set_global_state(key, get_global_state(key) + step)


# Decrease the state from global variable
func decrease_global_state(key: String, step: int) -> void:
	set_global_state(key, get_global_state(key) - step)


# Reset the global variable to default value
func reset_global() -> void:
	global_dict = default_global_dict.duplicate(true)


# ------ SUPPORTING FUNCIONS ------

func get_availability_from_dict(dictionary: Dictionary, head: String, key: String) -> bool:
	if (not dictionary.is_empty()) and (head in dictionary):
		if key in dictionary[head]:
			return true
		else:
			printerr("Invalid global key input")
	else:
		printerr("Invalid JSON Global")
	
	return false


# Load the Global variable JSON file
func load_json_resource(res: Resource) -> Dictionary:
	if (res is JSON) and (res.get_data() is Dictionary):
		return res.get_data()
	else:
		printerr("Invalid Global JSON format")
	
	return {}


# Get the distance between two object
func get_distance_3d(object1: Node3D, object2: Node3D) -> float:
	var pos_obj1: Vector3 = object1.global_transform.origin
	var pos_obj2: Vector3 = object2.global_transform.origin
	
	return pos_obj1.distance_to(pos_obj2)
