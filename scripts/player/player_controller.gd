extends CharacterBody3D

@onready var camera = $Camera3D

var mouse_sensitivity: float = 3.0

const SPEED = 5.0
const JUMP_VELOCITY = 5.0
const MOVEMENT_SMOOTHNESS = 8.0
const YAW_LIMIT_SMOOTHNESS = 5.0

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * (mouse_sensitivity / 20.0))
		camera.rotate_x(deg_to_rad(-event.relative.y) * (mouse_sensitivity / 20.0))
		print(deg_to_rad(-event.relative.x))

func _process(delta):
	var camera_yaw_limit = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	camera.rotation.x = lerp(camera.rotation.x, camera_yaw_limit, YAW_LIMIT_SMOOTHNESS * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_foreward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
