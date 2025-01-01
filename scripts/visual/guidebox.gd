extends Node3D

@export var guidebox_message: String = "This is Guidebox"

@onready var label: Label3D = $Label3D

func _process(delta: float) -> void:
	label.text = guidebox_message
