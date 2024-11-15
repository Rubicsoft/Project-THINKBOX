extends StaticBody3D

var prompt_msg = "Climbable Platform"

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func climb(velocity: Vector3, direction: Vector3, SPEED, MOVEMENT_SMOOTHNESS, delta: float) -> void:
	velocity.y = lerp(velocity.y, direction.x * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
