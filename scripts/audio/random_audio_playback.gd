extends AudioStreamPlayer3D
class_name RandomAudioPlayback


@export var is_playable: bool = true
@export var continuity: bool = false
@export var disable_hans_dialogue: bool = false
@export var audio_library: Array[AudioStream]


func _ready() -> void:
	connect("finished", Callable(self, "_on_finished"))


# Play the random audio
func play_audio() -> void:
	#is_playable = false if (disable_hans_dialogue and Global.get_global_condition("hans_on_dialogue")) else true
	
	if is_playable and (not Global.get_global_condition("hans_on_dialogue")):
		if not continuity:
			is_playable = false
		
		if not audio_library.is_empty():
			var random_sfx = audio_library[randi() % audio_library.size()]
			stream = random_sfx
			play()
		else:
			printerr("No random audio playback inputed")


# ------ SIGNAL ------

func _on_finished() -> void:
	if not continuity:
		is_playable = true
