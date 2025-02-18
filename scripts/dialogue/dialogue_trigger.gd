extends Area3D

@export var dialog_handler: DialogHandler


var dialogue_dict: Dictionary = {}


# SIGNAL

func _on_trigger_entered(body: Node3D) -> void:
	if dialog_handler:
		dialogue_dict = dialog_handler.dialogue_dict
		dialog_handler.set_gui_dialogue()
	else:
		printerr("DialogHandler Node not found")
	
	#if dialogue_dict != {}:
		#for i in range(dialogue_dict.get("chats", {}).size()):
			#if Global.get_global_condition("is_on_dialogue"):
				#print(dialogue_dict["chats"][i]["dialogue"])
	
