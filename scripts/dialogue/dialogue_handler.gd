extends Node
class_name DialogueHandler

# Exported Properties
## Play the dialogue once it toggled.
@export var play: bool = false:
	set(new_value):
		if new_value:
			play_dialogue()

@export var played: bool = false
## The dialogue can be played many times.
@export var reusable: bool = false
## If the dialogue is playing, the player can't be controlled.
@export var player_controlability: bool = true

@export_category("Dialogue Resources")
## Insert the JSON file of the dialogue here.
@export var dialogue_file: JSON
## Set up the dialogue user interface. If it's empty, the dialogue won't be displayed.
@export var dialogue_gui: DialogueGUI
## Custom AudioStreamPlayer. if it's empty, DialogueHandler will automatically create its own AudioStreamPlayer.
@export var audio_stream: AudioStreamPlayer

@export_category("Dialogue Parent")
## Custom dialogue timeline based on the parent's played property.
@export var played_parent: DialogueHandler


# DialogueJSON keywords
const CHATS = "chats"
const ACTOR = "actor"
const DIALOGUE = "dialogue"
const VOICE_PATH = "voice-path"
const DELAY = "delay"
const DISABLE_PLAYER_SFX = "disable-player-sfx"
const EMPTY_TIMER = "empty-timer"

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
		# Add new AudioStreamPlayer node when it's empty
		audio_stream = AudioStreamPlayer.new()
		audio_stream.bus = &"VO"
		add_child(audio_stream)


func _process(_delta: float) -> void:
	# If Played Parent is defined, the 'played' variable depends on the Played Parent node
	if played_parent and not played:
		played = played_parent.played



# ------ SUPPORTING FUNCTIONS ------

## Play the dialogue
func play_dialogue() -> void:
	if dialogue_dict.has(CHATS):
		if not played and (not Global.get_global_condition("is_on_dialogue")):
			played = true
			Global.set_global_condition("is_on_dialogue", true)
			Global.set_global_condition("show_dialogue_gui", true)
			
			# If the Player can't be controlled, disable its controlability
			if not player_controlability:
				Global.set_global_condition("is_player_controllable", false)
				var player: Player = Global.get_player()
				player.velocity = Vector3.ZERO
			
			# Play each dialogues
			for i in range(dialogue_dict[CHATS].size()):
				if dialogue_dict[CHATS][i].has(VOICE_PATH) and audio_stream:
					
					# Import the voice path
					audio_stream.stream = ResourceLoader.load(dialogue_dict[CHATS][i][VOICE_PATH])
					audio_stream.play()
					
					# If 'disable-player-sfx' is defined, disable the Player sound effects
					if dialogue_dict[CHATS][i].has(DISABLE_PLAYER_SFX):
						if dialogue_dict[CHATS][i][DISABLE_PLAYER_SFX]:
							Global.set_global_condition("hans_on_dialogue", true)
					
					# Set the DialogueGUI labels
					set_gui_dialogue(dialogue_dict[CHATS][i][ACTOR], dialogue_dict[CHATS][i][DIALOGUE])
					
					# Wait for the audio to be finished
					await audio_stream.finished
					Global.set_global_condition("hans_on_dialogue", false)
					
					
					# if 'delay' is defined, add delay to the current dialogue
					if dialogue_dict[CHATS][i].has(DELAY):
						Global.set_global_condition("show_dialogue_gui", false)
						
						await set_dialogue_delay(dialogue_dict[CHATS][i][DELAY]).timeout
						
						Global.set_global_condition("show_dialogue_gui", true)
					
				else:
					# If 'voice-path' is not defined and there is no AudioStreamPlayer, add timer to the current dialogue
					const default_voice_duration: float = 2.0
					
					# Set the DialogueGUI
					set_gui_dialogue(dialogue_dict[CHATS][i][ACTOR], dialogue_dict[CHATS][i][DIALOGUE])
					
					
					# Set the timer. If 'empty-timer' is defined, use its value for the timing, or else use default.
					if dialogue_dict[CHATS][i].has(EMPTY_TIMER):
						await set_dialogue_delay(dialogue_dict[CHATS][i][EMPTY_TIMER]).timeout
						
					else:
						await set_dialogue_delay(default_voice_duration).timeout
			
			
			Global.set_global_condition("is_on_dialogue", false)
			Global.set_global_condition("show_dialogue_gui", false)
			
			if not player_controlability:
				Global.set_global_condition("is_player_controllable", true)
			if reusable:
				played = false
		
	else:
		# Invalid DialogueJSON format when 'chats' is not defined
		printerr("No <" + CHATS + "> key found inside DialogueJSON in " + get_parent().name + "/" + name)


# ON-PROGRESS : This function is needed for safety purpose and avoid any crash at runtime.
## Check if the Dialogue Dictionary is valid
func is_dialogue_dict_valid(dict: Dictionary) -> bool:
	if dict.has(CHATS):
		if dict[CHATS].has(ACTOR) and dict[CHATS].has(DIALOGUE):
			return true
	
	printerr("Invalid JSON format for DialogueHandler at Node : " + get_parent().name + "/" + name)
	return false


## Set the DialogueGUI elements
func set_gui_dialogue(actor_label: String, chat_label: String) -> void:
	if dialogue_gui and (not dialogue_dict.is_empty()):
		dialogue_gui.actor_label.text = actor_label
		dialogue_gui.chat_label.text = chat_label


## Set up delay timer
func set_dialogue_delay(duration: float) -> SceneTreeTimer:
	return get_tree().create_timer(duration, false, false, true)
