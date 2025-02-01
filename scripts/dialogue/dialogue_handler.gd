extends Node
class_name DialogHandler

@export var dialogue_file: JSON

var dialogue_dict: Dictionary


func _ready() -> void:
	if dialogue_file:
		dialogue_dict = get_dialogue(dialogue_file)


func get_dialogue(json: JSON) -> Dictionary:
	if json.get_data() is Dictionary:
		return json.get_data()
	else:
		printerr("Invalid JSON format")
	
	return {}
