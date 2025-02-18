extends Area3D

@export var destination: Node3D


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_teleport_enter"))


func _on_teleport_enter(body: Node3D) -> void:
	if (body is Player) and destination:
		body.global_position = destination.global_position
		body.global_rotation.y = destination.global_rotation.y
		#body.camera_fx.play_effect("glitch_fadeout", false)
