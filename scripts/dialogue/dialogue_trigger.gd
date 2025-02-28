extends Area3D

@export var dialog_handler: DialogHandler


# SIGNAL

func _on_trigger_entered(body: Node3D) -> void:
	if dialog_handler:
		dialog_handler.play = true
	else:
		printerr("DialogHandler Node not found in " + name)
	
