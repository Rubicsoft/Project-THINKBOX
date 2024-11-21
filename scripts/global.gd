extends Node

var state: Dictionary = {
	"square_key" : 0
}

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
