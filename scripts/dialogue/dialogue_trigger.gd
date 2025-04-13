extends Area3D

@export var dialogue_handler: DialogueHandler


# SIGNAL

func _on_trigger_entered(body: Node3D) -> void:
	if dialogue_handler:
		dialogue_handler.play = true
	else:
		printerr("DialogHandler Node not found in " + name)
	
