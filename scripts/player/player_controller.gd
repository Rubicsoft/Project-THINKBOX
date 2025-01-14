extends CharacterBody3D
class_name Player

# Nodes
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var interact_raycast: RayCast3D = $CameraPivot/Camera3D/InteractRayCast
@onready var camera_animation: AnimationPlayer = $CameraPivot/CameraAnimation
@onready var camera_fx: Control = $CameraFX
@onready var quickclimb_raycast: RayCast3D = $QuickClimbRaycast
@onready var after_dying: Timer = $AfterDying

# Sound Effects
@onready var run_sfx = $Audios/Run
@onready var jump_sfx = $Audios/Jump
@onready var player_voice = $Audios/PlayerVoice
@onready var jump_ground = $Audios/JumpGround

@export_range(0.1, 15.0, 0.1) var SPEED: float = 5.0
@export_range(0.1, 12.5, 0.1) var JUMP_VELOCITY = 8.0
@export_range(0.1, 12.5, 0.1) var QUICKCLIMB_ENERGY = 8.0
@export_range(1.0, 5.0, 1.0) var SPECTATOR_SPEED_MULTIPLIER: float = 2.0

var gamepad_look_sensitivity: float = 3.0
var was_in_air: bool = false
var fall_velocity_before: float
var spec_double_speed: bool = false

# Constants
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
			rotate_y(deg_to_rad(-event.relative.x) * (GameSettings.mouse_sensitivity / 20.0))
			camera.rotate_x(deg_to_rad(-event.relative.y) * (GameSettings.mouse_sensitivity / 20.0))
		
		
		if event.is_action_pressed("spectator"):
			Global.spectator_mode = not Global.spectator_mode
		if event.is_action_pressed("tap") and Global.spectator_mode:
			spec_double_speed = not spec_double_speed
			match spec_double_speed:
				true:
					SPEED = SPEED * 2.0
				false:
					SPEED = SPEED * 1/2.0
		if not Global.spectator_mode:
			spec_double_speed = false
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
	if not is_on_floor() and not Global.spectator_mode:
		velocity += get_gravity() * 2.0 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not Global.spectator_mode:
		jump()

	# Handle movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_foreward", "move_backward")
	if Global.is_player_controllable:
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = lerp(velocity.x, direction.x * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
			velocity.z = lerp(velocity.z, direction.z * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
			if is_on_floor():
				if GameSettings.head_bobing:
					camera_animation.play("player_walking")
				run_sfx.play_audio()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Global.spectator_mode:
		var spectator_updown = Input.get_axis("go_down", "go_up")
		var spectator_direction = (transform.basis * Vector3(input_dir.x, spectator_updown, input_dir.y)).normalized()
		if spectator_direction:
			velocity.y = lerp(velocity.y, spectator_direction.y * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	quick_climbing()
	take_fall()


func take_fall() -> void:
	if not is_on_floor():
		# Get value for next frame
		was_in_air = true
		fall_velocity_before = velocity.y
		
	elif was_in_air and is_on_floor():
		camera_animation.play("player_jump", -1, 3.0)
		was_in_air = false
		fall_velocity_before = velocity.y


# Quick climbing mechanic
func quick_climbing() -> void:
	if quickclimb_raycast.is_colliding() and not is_on_floor() and Input.is_action_pressed("move_foreward"):
		var hit_obj: Object = quickclimb_raycast.get_collider()
		if hit_obj is FloatingPlatform:
			velocity.y = QUICKCLIMB_ENERGY
			jump(false)
			#print(hit_obj.collision_layer)


# Handle Jump
func jump(do_action: bool = true) -> void:
	if do_action:
		velocity.y = JUMP_VELOCITY
	camera_animation.play("player_jump")
	jump_sfx.play_audio()
	jump_ground.play()


# To kill the Player
func kill_self() -> void:
	Checkpoint.respawn(self)
	Global.increase_value("death_count")
	camera_fx.play_effect("glitch_fadeout", false)


func crouch(event: InputEvent) -> void:
	pass

func _on_after_dying_timeout() -> void:
	Global.is_player_controllable = true
