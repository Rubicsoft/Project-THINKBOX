extends AnimatableBody3D
class_name FloatingPlatform


@export var is_moving: bool = false
@export var end_position: Node3D
@export_range(0.0, 10.0, 0.1) var duration: float = 5.0
@export_range(0.0, 10.0, 0.1) var delay_time: float = 0.0
@export var sine_interpolation: bool = false


var start_position: Vector3


func _ready():
	start_position = global_position
	tweening()
	

# Move the platform using Tweening method
func tweening() -> void:
	if end_position and is_moving:
		# Tweening setup
		var tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops()
		if sine_interpolation:
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_SINE)
		
		# Tweening movement
		tween.tween_interval(delay_time)
		tween.tween_property(self, "global_position", end_position.global_position, calculate_duration())
		
		tween.tween_interval(delay_time)
		tween.tween_property(self, "global_position", global_position, calculate_duration())


# Calculate the duration of the moving platform
func calculate_duration() -> float:
	return duration/2.0 - delay_time
