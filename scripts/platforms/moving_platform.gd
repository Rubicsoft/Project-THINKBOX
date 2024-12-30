extends AnimatableBody3D
class_name FloatingPlatform

@export var is_moving: bool = false
@export var end_position: Node3D
@export_range(0.0, 10.0, 0.1) var duration: float = 5.0

var start_position: Vector3

func _ready():
	start_position = global_position
	
	tweening()
	

func tweening() -> void:
	if end_position and is_moving:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", end_position.global_position, duration)
