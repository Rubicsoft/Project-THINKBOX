extends AudioStreamPlayer3D

@export var is_playable: bool = true
@export var continuity: bool = false

# NOTE : Issue! if the audios imported is less than 3, the audio will stop playing and not looping

@export var audio_1: AudioStream
@export var audio_2: AudioStream
@export var audio_3: AudioStream

var sounds = []

func _ready() -> void:
	connect("finished", Callable(self, "_on_finished"))
	sounds = [audio_1, audio_2, audio_3]

func play_audio() -> void:
	if is_playable:
		if not continuity:
			is_playable = false
		var random_sfx = sounds[randi() % sounds.size()]
		stream = random_sfx
		play()

func _on_finished() -> void:
	is_playable = true
