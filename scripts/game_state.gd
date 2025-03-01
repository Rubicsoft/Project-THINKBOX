extends Node3D
class_name GameSceneState

@export var player: Player


func _ready() -> void:
	# Make the mouse invisible and centered when in gameplay
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
