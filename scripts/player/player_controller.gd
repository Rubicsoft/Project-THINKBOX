extends CharacterBody3D
class_name Player

# Nodes
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var interact_raycast: RayCast3D = $CameraPivot/Camera3D/InteractRayCast
@onready var camera_animation: AnimationPlayer = $CameraPivot/CameraAnimation
@onready var camera_fx: Control = $CameraFX
@onready var quickclimb_raycast: RayCast3D = $QuickClimbing/QuickClimbRaycast
@onready var max_ray_height: Node3D = $QuickClimbing/MaxRayHeight
@onready var after_dying: Timer = $AfterDying
@onready var player_collision_shape: CollisionShape3D = $CollisionShape3D
# Sound Effects
@onready var run_sfx = $Audios/Run
@onready var jump_sfx = $Audios/Jump
@onready var player_voice = $Audios/PlayerVoice
@onready var jump_ground = $Audios/JumpGround



# Exported Properties
@export_group("Speed")
## Controls how fast the Player moves
@export_range(0.1, 15.0, 0.1) var SPEED: float = 5.0
## Smooth-out the Player's movement when running
@export_range(1.0, 12.0, 0.1) var MOVEMENT_SMOOTHNESS: float = 8.0
## Smooth-out the Player's movement when it's on air
@export_range(1.0, 12.0, 0.1) var ON_AIR_MOVEMENT_SMOOTHNESS: float = 3.0

@export_group("Movement Skill")
## Controls how high the Player jumps
@export_range(0.1, 12.5, 0.1) var JUMP_VELOCITY = 8.0
## Controls the Player's dash force
@export_range(1, 20, 0.1) var DASH_SPEED: float = 10.0

@export_group("Quick Climbing")
## Maximum force of QuickClimb mechanic
@export_range(1.0, 5.0, 0.1) var MAX_QUICKCLIMB_FORCE: float = 2.0
## Minimum force of QuickClimb mechanic
@export_range(0.1, 1.0, 0.1) var MIN_QUICKCLIMB_FORCE: float = 1.0

@export_group("Cheat")
@export_range(1.0, 5.0, 1.0) var SPECTATOR_SPEED_MULTIPLIER: float = 2.0

@export_group("Camera")
## Smooth-out the camera pitch rotation
@export_range(0.1, 1.0, 0.1) var PITCH_SMOOTHING_STRENGTH: float = 0.7
## Multiplies the mouse/gamepad sensitivity.
@export_range(0.0, 1.0, 0.1) var SENSITIVITY_MULTIPLIER: float = 1.0


@export_category("Player's Custom Ability")
## Player can jump if it sets to TRUE.
@export var can_jump: bool = true
## Player can quick climb if it sets to TRUE.
@export var can_quick_climb: bool = true
## Player can dash if it sets to TRUE
@export var can_dash: bool = true
## Player will be headbobing when walking if it sets to TRUE.
@export var head_bobing: bool = true



# Variables
var was_in_air: bool = false
var fall_velocity_before: float
var spec_double_speed: bool = false
var mouse_y_sensitivity: float
var gamepad_y_sensitivity: float
var quickclimb_pos_increment: float
var init_qc_ray_pos: Vector3
var max_qc_ray_distance: float

# Constants
const PITCH_ROTATION_LIMIT = 60.0



func _ready():
	# Default checkpoint position
	Checkpoint.last_position = global_position
	
	init_qc_ray_pos = quickclimb_raycast.position
	quickclimb_pos_increment = MIN_QUICKCLIMB_FORCE

func _input(event) -> void:
	# Handle camera movement based on mouse input
	if Global.get_global_condition("is_player_controllable"):
		mouse_look_input(event)
		
		
		if event.is_action_pressed("spectator"):
			#Global.spectator_mode = not Global.spectator_mode
			Global.set_global_condition("spectator_mode", not Global.get_global_condition("spectator_mode"))
		
		if event.is_action_pressed("tap") and Global.get_global_condition("spectator_mode"):
			spec_double_speed = not spec_double_speed
			match spec_double_speed:
				true:
					SPEED = SPEED * 2.0
				false:
					SPEED = SPEED * 1/2.0
		if not Global.get_global_condition("spectator_mode"):
			spec_double_speed = false
		
		
		quickclimb_ray_heightpos(event, max_ray_height.position.y, MIN_QUICKCLIMB_FORCE, MAX_QUICKCLIMB_FORCE)


func _process(delta) -> void:
	# Clamp the pitch rotation so that it won't be over-rotate
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-PITCH_ROTATION_LIMIT), deg_to_rad(PITCH_ROTATION_LIMIT))
	
	gamepad_look_input(delta)		# Handles gamepad input for camera looking
	pitch_sensitivity_smoothing(PITCH_ROTATION_LIMIT, PITCH_SMOOTHING_STRENGTH)


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor() and not Global.get_global_condition("spectator_mode"):
		velocity += get_gravity() * 2.0 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not Global.get_global_condition("spectator_mode"):
		jump()
	
	# Handle movement
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_foreward", "move_backward")
	var direction: Vector3 = move_player(input_dir, delta)
	
	spectator_controller(input_dir, delta)		# Spectator Mode Controller
	dash(direction)								# Dashing system
	quick_climbing()							# Quick climb/ledge
	take_fall()									# Player takes fall
	
	move_and_slide()



# ------ SUPPORTING FUNCTIONS ------

## Handle Player's movement
func move_player(input_dir: Vector2, delta: float) -> Vector3:
	if Global.get_global_condition("is_player_controllable"):
		var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		
		if direction:
			if is_on_floor():
				velocity.x = lerp(velocity.x, direction.x * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
				velocity.z = lerp(velocity.z, direction.z * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
				if is_on_floor():
					if GameSettings.head_bobing and head_bobing:
						camera_animation.play("player_walking")
					run_sfx.play_audio()
			else:
				velocity.x = lerp(velocity.x, direction.x * SPEED * 100.0 * delta, ON_AIR_MOVEMENT_SMOOTHNESS * delta)
				velocity.z = lerp(velocity.z, direction.z * SPEED * 100.0 * delta, ON_AIR_MOVEMENT_SMOOTHNESS * delta)
		else:
			if is_on_floor() or Global.get_global_condition("spectator_mode"):
				velocity.x = move_toward(velocity.x, 0.0, SPEED * delta * 10.0)
				velocity.z = move_toward(velocity.z, 0.0, SPEED * delta * 10.0)
		
		return direction
	
	return Vector3.ZERO


## Handles camera rotation based on mouse input
func mouse_look_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * (GameSettings.mouse_sensitivity / 20.0) * SENSITIVITY_MULTIPLIER)
		camera.rotate_x(deg_to_rad(-event.relative.y) * (mouse_y_sensitivity / 20.0) * SENSITIVITY_MULTIPLIER)


## Handles gamepad input for camera looking
func gamepad_look_input(delta: float) -> void:
	if Global.get_global_condition("is_player_controllable"):
		var gamepad_look_dir: Vector2 = Input.get_vector("gamepad_look_left", "gamepad_look_right", "gamepad_look_down", "gamepad_look_up")
		
		rotate_y(-gamepad_look_dir.x * (GameSettings.gamepad_look_sensitivity * 2.0) * SENSITIVITY_MULTIPLIER * delta)
		camera.rotate_x(gamepad_look_dir.y * (gamepad_y_sensitivity * 2.0) * SENSITIVITY_MULTIPLIER * delta)


## Smooth-out the MouseY sensitivity until it reaches its maximum pitch rotation
func pitch_sensitivity_smoothing(max_pitch: float, strength: float) -> void:
	var normalized_pitch: float = rad_to_deg(camera.rotation.x) / abs(max_pitch)
	var scale_factor: float = 1.0 - (abs(normalized_pitch) * strength)
	
	scale_factor = max(scale_factor, 0.1)
	
	mouse_y_sensitivity = GameSettings.mouse_sensitivity * scale_factor
	gamepad_y_sensitivity = GameSettings.gamepad_look_sensitivity * scale_factor


## Spectator Mode controller
func spectator_controller(input_dir: Vector2, delta: float) -> void:
	if Global.get_global_condition("spectator_mode") and Global.get_global_condition("is_player_controllable"):
		player_collision_shape.disabled = true
		
		var spectator_updown = Input.get_axis("go_down", "go_up")
		var spectator_direction = (transform.basis * Vector3(input_dir.x, spectator_updown, input_dir.y)).normalized()
		if spectator_direction:
			velocity.y = lerp(velocity.y, spectator_direction.y * SPEED * 100.0 * delta, MOVEMENT_SMOOTHNESS * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		player_collision_shape.disabled = false


## Player takes some action when fall
func take_fall() -> void:
	if not is_on_floor():
		# Get value for next frame
		was_in_air = true
		fall_velocity_before = velocity.y
		
	elif was_in_air and is_on_floor():
		camera_animation.play("player_jump", -1, 3.0)
		was_in_air = false
		fall_velocity_before = velocity.y


## Quick climbing mechanic
func quick_climbing() -> void:
	if can_quick_climb:
		if quickclimb_raycast.is_colliding() and not is_on_floor() and Input.is_action_pressed("move_foreward"):
			# Do Actions
			get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).tween_property(self, "global_position:y", global_position.y + quickclimb_pos_increment, 0.1)
			#jump(false)
			velocity = Vector3.ZERO


## Adjust QuickClimb raycast position based on camera angle
func quickclimb_ray_heightpos(event: InputEvent, max_height: float, min_energy: float, max_energy: float) -> void:
	if event is InputEventMouseMotion:
		if camera.rotation.x > 0:
			var normalized_pitch: float = rad_to_deg(camera.rotation.x) / PITCH_ROTATION_LIMIT
			
			# Adjust the raycast y-position
			var position_threshold: float = (max_height - init_qc_ray_pos.y) * normalized_pitch
			quickclimb_raycast.position = Vector3(init_qc_ray_pos.x, init_qc_ray_pos.y + position_threshold, init_qc_ray_pos.z)
			
			# Adjust the energy
			var energy_threshold: float = (max_energy - min_energy) * normalized_pitch
			quickclimb_pos_increment = energy_threshold + min_energy
			
		else:
			# Reset to initial value
			quickclimb_raycast.position = init_qc_ray_pos
			quickclimb_pos_increment = min_energy


## Handles Jump
func jump(do_action: bool = true) -> void:
	if can_jump and Global.get_global_condition("is_player_controllable"):
		if do_action:
			velocity.y = JUMP_VELOCITY
		camera_animation.play("player_jump")
		jump_sfx.play_audio()
		jump_ground.play()


## Handles dashing
func dash(input_direction: Vector3) -> void:
	const dash_fov = 30.0
	
	if can_dash:
		if Input.is_action_just_pressed("dash") and Global.get_global_state("dash_orbs") > 0:
			if input_direction != Vector3.ZERO:
				velocity.x = (SPEED * DASH_SPEED) * input_direction.normalized().x
				velocity.z = (SPEED * DASH_SPEED) * input_direction.normalized().z
				
				Global.decrease_global_state("dash_orbs", 1)
				whoosh_camera(dash_fov)


## Make camera whoosh animation
func whoosh_camera(fov: float) -> void:
	var anim = get_tree().create_tween()
	anim.set_trans(Tween.TRANS_SINE)
	
	anim.tween_property(camera, "fov", camera.fov - fov, 0.05)
	anim.tween_property(camera, "fov", camera.fov + fov, 0.05)


## To kill the Player
func kill_self() -> void:
	Checkpoint.respawn(self)
	Global.increase_global_state("death_count", 1)
	Global.set_global_state("dash_orbs", 0)
	camera_fx.play_effect("glitch_fadeout", false)



# ------ SIGNALS ------

func _on_after_dying_timeout() -> void:
	Global.set_global_condition("is_player_controllable", true)
