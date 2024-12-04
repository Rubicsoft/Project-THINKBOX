extends CharacterBody3D
class_name Player

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var interact_raycast: RayCast3D = $CameraPivot/Camera3D/InteractRayCast
@onready var camera_animation: AnimationPlayer = $CameraPivot/CameraAnimation
@onready var quickclimb_raycast: RayCast3D = $QuickClimbRaycast
@onready var after_dying: Timer = $AfterDying
# Sound Effects
@onready var run_sfx = $Audios/Run
@onready var jump_sfx = $Audios/Jump
@onready var player_voice = $Audios/PlayerVoice
@onready var jump_ground = $Audios/JumpGround

var mouse_sensitivity: float = 3.0
var gamepad_look_sensitivity: float = 3.0
var was_in_air: bool = false
var fall_velocity_before: float

# Constants
const SPEED = 5.0
const JUMP_VELOCITY = 5.0
const MOVEMENT_SMOOTHNESS = 8.0
const YAW_LIMIT_SMOOTHNESS = 5.0
const FALL_DAMAGE_SPEED = 20.0

func _ready():
	Checkpoint.last_position = global_position
	#player_voice.play()

func _input(event) -> void:
	# Handle camera movement based on mouse input
	if Global.is_player_controllable:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x) * (mouse_sensitivity / 20.0))
			camera.rotate_x(deg_to_rad(-event.relative.y) * (mouse_sensitivity / 20.0))
	
	#var gamepad_look_dir: Vector2 = Input.get_vector("gamepad_look_left", "gamepad_look_right", "gamepad_look_down", "gamepad_look_up")
	#print(gamepad_look_dir)
	#rotate_y(-gamepad_look_dir.x * gamepad_look_sensitivity / 20.0)
	#camera.rotate_x(gamepad_look_dir.y * gamepad_look_sensitivity / 20.0)

func _process(delta) -> void:
	# Limit the camera yaw and also smooth it out
	var camera_yaw_limit = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
	if is_on_floor():
		camera.rotation.x = lerp(camera.rotation.x, camera_yaw_limit, YAW_LIMIT_SMOOTHNESS * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		camera_animation.play("player_jump")
		jump_sfx.play_audio()
		jump_ground.play()

	# Handle movement
	if Global.is_player_controllable:
		var input_dir = Input.get_vector("move_left", "move_right", "move_foreward", "move_backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
			velocity.z = lerp(velocity.z, direction.z * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
			if is_on_floor():
				camera_animation.play("player_walking")
				run_sfx.play_audio()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	quick_climbing()
	fall_dying()

func fall_dying() -> void:
	if not is_on_floor():
		# Get value for next frame
		was_in_air = true
		fall_velocity_before = velocity.y
	elif fall_velocity_before < -FALL_DAMAGE_SPEED and was_in_air and is_on_floor():
		# Dying action
		Checkpoint.respawn(self)
		Global.decrease_value("life_left")
		
		# Reset value for previeous variables
		was_in_air = false
		fall_velocity_before = velocity.y

func quick_climbing() -> void:
	if quickclimb_raycast.is_colliding() and not is_on_floor() and Input.is_action_pressed("move_foreward"):
		var hit_obj: Object = quickclimb_raycast.get_collider()
		if hit_obj is AnimatableBody3D:
			velocity.y = 5.0

func _on_after_dying_timeout() -> void:
	Global.is_player_controllable = true
