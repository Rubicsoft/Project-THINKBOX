extends Control
class_name DialogueGUI

@onready var actor_label: Label = $VBoxContainer/ActorLabel
@onready var chat_label: Label = $VBoxContainer/ChatLabel


func _process(delta: float) -> void:
	# Only visible when inside the dialogue
	visible = Global.get_global_condition("is_on_dialogue")
