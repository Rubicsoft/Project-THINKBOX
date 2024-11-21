extends Node

var state: Dictionary = {
	"live_left" : 3
}
var default_state: Dictionary

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
