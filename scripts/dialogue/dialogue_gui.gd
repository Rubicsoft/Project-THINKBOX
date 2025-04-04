extends Control
class_name DialogueGUI

@onready var actor_label: Label = $Dialogue/ActorLabel
@onready var chat_label: Label = $Dialogue/ChatLabel

@onready var dialogue: VBoxContainer = $Dialogue


signal gui_visibility_changed(visibility: bool)
var gui_visible: bool = false:
	set(new_value):
		gui_visible = new_value
		emit_signal("gui_visibility_changed", new_value)

var gui_tween: Tween



func _ready() -> void:
	connect("gui_visibility_changed", Callable(self, "_on_gui_visible"))
	
	# Default property when first time loaded
	visible = false
	dialogue.modulate = Color.TRANSPARENT


func _process(_delta: float) -> void:
	# Only visible when inside the dialogue
	gui_visible = Global.get_global_condition("is_on_dialogue")



# ------ SIGNALS ------

func _on_gui_visible(visibility: bool) -> void:
	match visibility:
		true:
			visible = true
			
			gui_tween = get_tree().create_tween()
			gui_tween.set_ease(Tween.EASE_IN)
			gui_tween.set_trans(Tween.TRANS_QUAD)
			
			gui_tween.tween_property(dialogue, "modulate", Color.WHITE, 0.1)
		
		false:
			gui_tween = get_tree().create_tween()
			
			gui_tween.tween_property(dialogue, "modulate", Color.TRANSPARENT, 0.1)
			
			await gui_tween.finished
			visible = false
