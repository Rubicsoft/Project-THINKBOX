extends AnimatableBody3D

@export var is_moving: bool = false
@export var end_position: Node3D
@export_range(0.0, 10.0, 0.1) var duration: float = 5.0

var start_position: Vector3
