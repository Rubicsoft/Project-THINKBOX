extends AudioStreamPlayer3D

var sounds = []
var is_playable: bool = true

func _ready() -> void:
	sounds = [
		preload("res://assets/sounds/footsteps/footstep_01.ogg"),
		preload("res://assets/sounds/footsteps/footstep_02.ogg"),
		preload("res://assets/sounds/footsteps/footstep_03.ogg")
	]

func play_audio() -> void:
	if is_playable:
		is_playable = false
		var random_sfx = sounds[randi() % sounds.size()]
		stream = random_sfx
		play()

func _on_finished():
	is_playable = true
