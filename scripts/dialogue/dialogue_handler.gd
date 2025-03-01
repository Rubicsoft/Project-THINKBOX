extends Node
class_name DialogHandler


@export var play: bool = false:
	set(new_value):
		if new_value:
			play_dialogue()
			played = true

@export var played: bool = false
@export var dialogue_file: JSON
@export var dialogue_gui: DialogueGUI
@export var audio_stream: AudioStreamPlayer
@export var player_controlability: bool = true

# DialogueJSON keywords
const CHATS = "chats"
const ACTOR = "actor"
const DIALOGUE = "dialogue"
const VOICE_PATH = "voice-path"
const DISABLE_PLAYER_SFX = "disable-player-sfx"

# Contains the dialogue data
var dialogue_dict: Dictionary = {}



func _ready() -> void:
	# Load the JSON file
	if dialogue_file:
		dialogue_dict = Global.load_json_resource(dialogue_file)
	else:
		printerr("No dialogue file available in " + get_parent().name + "/" + name)
	
	# Set the AudioStreamPlayer settings
	if audio_stream:
		audio_stream.bus = &"VO"
	else:
		printerr("No AudioStreamPlayer available in " + get_parent().name + "/" + name)


# ------ SUPPORTING FUNCTIONS ------

# Play the dialogue
func play_dialogue() -> void:
	if dialogue_dict.has(CHATS):
		if not played and audio_stream:
			played = true
			Global.set_global_condition("is_on_dialogue", true)
			
			if not player_controlability:
				Global.set_global_condition("is_player_controllable", false)
				var player: Player = Global.get_player()
				player.velocity = Vector3.ZERO
			
			# Play each dialogues
			for i in range(dialogue_dict[CHATS].size()):
				if dialogue_dict[CHATS][i].has(VOICE_PATH):
					
					audio_stream.stream = ResourceLoader.load(dialogue_dict[CHATS][i][VOICE_PATH])
					audio_stream.play()
					
					if dialogue_dict[CHATS][i].has(DISABLE_PLAYER_SFX):
						if dialogue_dict[CHATS][i][DISABLE_PLAYER_SFX]:
							Global.set_global_condition("hans_on_dialogue", true)
					
					set_gui_dialogue(dialogue_dict[CHATS][i][ACTOR], dialogue_dict[CHATS][i][DIALOGUE])
					
					await audio_stream.finished
					Global.set_global_condition("hans_on_dialogue", false)
					
				else:
					const empty_voice_duration: float = 1.0
					
					set_gui_dialogue(dialogue_dict[CHATS][i][ACTOR], dialogue_dict[CHATS][i][DIALOGUE])
					await get_tree().create_timer(empty_voice_duration).timeout
			
			Global.set_global_condition("is_on_dialogue", false)
			if not player_controlability:
				Global.set_global_condition("is_player_controllable", true)
		
	else:
		printerr("No <" + CHATS + "> key found inside DialogueJSON in " + get_parent().name + "/" + name)


# Set the DialogueGUI elements
func set_gui_dialogue(actor_label: String, chat_label: String) -> void:
	if dialogue_gui and (not dialogue_dict.is_empty()):
		dialogue_gui.actor_label.text = actor_label
		dialogue_gui.chat_label.text = chat_label
