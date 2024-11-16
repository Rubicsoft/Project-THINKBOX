extends AudioStreamPlayer3D

var sounds = []

func _ready():
	sounds = [
		preload("res://assets/sounds/jump_01.ogg"),
		preload("res://assets/sounds/jump_02.ogg"),
		preload("res://assets/sounds/jump_03.ogg")
	]

func play_audio() -> void:
	var random_sfx = sounds[randi() % sounds.size()]
	stream = random_sfx
	play()
