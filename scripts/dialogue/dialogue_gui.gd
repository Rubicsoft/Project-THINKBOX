extends Control
class_name DialogueGUI

@onready var actor: Label = $Dialogue/ActorLabel
@onready var chat: Label = $Dialogue/ChatLabel
@onready var actor_profile: TextureRect = $ActorProfile
@onready var actor_profile_showup_anim: AnimationPlayer = $ActorProfile/ShowUp



func _ready() -> void:
	# Default property when first time loaded
	visible = false
	actor_profile.visible = false


func _process(_delta: float) -> void:
	# Only visible when inside the dialogue
	visible = Global.get_global_condition("show_dialogue_gui") and (not get_tree().paused)



# ------ SUPPORTING FUNCTIONS ------

# Set the Actor and Dialogue label on DialogueGUI
func set_gui_dialogue(actor_label: String, chat_label: String) -> void:
	actor.text = actor_label
	chat.text = chat_label


# Show actor profile
func show_profile(profile_img: String) -> void:
	actor_profile.texture = ResourceLoader.load(profile_img)
	actor_profile_showup_anim.play("show_up")
	actor_profile.visible = true


# Hide the actor profile
func close_profile() -> void:
	actor_profile.visible = false
