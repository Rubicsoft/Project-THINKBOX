extends Node

var is_player_controllable: bool = true

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
