extends AnimatableBody3D
class_name FloatingPlatform

@export var is_moving: bool = false
@export var end_position: Node3D
@export_range(0.0, 10.0, 0.1) var duration: float = 5.0
@export var delay: bool = false
@export_range(0.0, 10.0, 0.1) var delay_time: float = 1.0

var start_position: Vector3


func _ready():
	start_position = global_position
	tweening()
	

func tweening() -> void:
	if end_position and is_moving:
		var tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		
		delay_between(tween)
		tween.tween_property(self, "global_position", end_position.global_position, calculate_duration())
		delay_between(tween)
		tween.tween_property(self, "global_position", global_position, calculate_duration())


func calculate_duration() -> float:
	if delay:
		return duration/2.0 - delay_time
	else:
		return duration/2.0


func delay_between(tween) -> void:
	if delay:
		tween.tween_interval(delay_time)
