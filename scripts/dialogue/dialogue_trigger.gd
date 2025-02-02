extends Area3D

var dialogue_dict: Dictionary = {}

# SIGNAL

func _on_trigger_entered(body: Node3D) -> void:
	for i in range(get_child_count()):
		if get_child(i) is DialogHandler:
			dialogue_dict = get_child(i).dialogue_dict
	
	if dialogue_dict != {}:
		for i in range(dialogue_dict.get("chats", {}).size()):
			print(dialogue_dict["chats"][i]["dialogue"])
	
