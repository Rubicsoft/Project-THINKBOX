extends Node
class_name DialogHandler

@export var play_dialogue: bool = false
@export var dialogue_file: JSON
@export var dialogue_gui: DialogueGUI

var dialogue_dict: Dictionary = {}


func _ready() -> void:
	if dialogue_file:
		dialogue_dict = Global.load_json_resource(dialogue_file)

#func _process(delta: float) -> void:
	#Global.is_on_dialogue = play_dialogue


func set_gui_dialogue() -> void:
	if dialogue_gui and (dialogue_dict != {}):
		dialogue_gui.actor_label.text = dialogue_dict["chats"][0]["actor"]
		dialogue_gui.chat_label.text = dialogue_dict["chats"][0]["dialogue"]
