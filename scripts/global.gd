extends Node

var is_player_controllable: bool = true
var is_pausable: bool = true
var is_playing_cutscene: bool = false
var spectator_mode: bool = false

var state: Dictionary = {
	"death_count" : 0, 
	"codex_collected" : 0
}
var default_state

func _ready():
	default_state = state

func get_value(key):
	if state.has(key):
		return state[key]
	printerr("There is no key called", key)

func set_state(key, value) -> void:
	state[key] = value

func decrease_value(key) -> void:
	state[key] = state[key] - 1

func increase_value(key) -> void:
	state[key] = state[key] + 1

func reset_state() -> void:
	state = default_state


func get_distance_3d(object1: Node3D, object2: Node3D) -> float:
	var pos_obj1: Vector3 = object1.global_transform.origin
	var pos_obj2: Vector3 = object2.global_transform.origin
	
	return pos_obj1.distance_to(pos_obj2)
