extends StaticBody3D

@export var prompt_msg: String = "Just a book :v"
@onready var sound = $Sound

func interact() -> void:
	sound.play()
