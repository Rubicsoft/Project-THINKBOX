extends Node3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta) -> void:
	if Global.get_value("life_left") <= 0:
		get_tree().quit()
