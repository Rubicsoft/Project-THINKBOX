extends Control
class_name DialogueGUI

func _process(delta: float) -> void:
	visible = Global.is_on_dialogue
