extends Area3D

@export var end_position: Node3D
@export_range(0.1, 10.0, 0.1) var duration: float = 2.0
@export var one_shot: bool = false
@export_range(0.0, 3.0, 0.1) var anticipation_duration: float = 1.0
@export var triggerbox: Area3D
@export var sine_interpolation: bool = false


# Variables
var position_origin: Vector3 = Vector3.ZERO

var triggered: bool = false:
	set(new_value):
		triggered = new_value
		if new_value == false:
			reset_laser()

var collision_shapes: Array[CollisionShape3D]
var tween: Tween



func _ready() -> void:
	position_origin = global_position
	
	# Get the children: CollisionShape3D
	collision_shapes = get_collision_shapes()
	
	# Adjust some settings if Triggerbox is defined
	if triggerbox:
		visible = false
		triggerbox.set_collision_mask_value(2, true)
		disable_collision_shapes(collision_shapes, true)
	
	# Do Actions
	if end_position:
		match one_shot:
			true:
				if triggerbox:
					triggerbox.connect("body_entered", Callable(self, "_on_oneshot_attack"))
				else:
					printerr("Triggerbox for One-Shot Laser is not found in Node: " + get_parent().name + "/" + name)
				
			false:
				if triggerbox:
					triggerbox.connect("body_entered", Callable(self, "_on_looping_attack"))
				else:
					looping(end_position)



# ------ SUPPORTING FUNCTIONS ------

# Create the tween variable
func create_tweening() -> void:
	tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if not one_shot:
		tween.set_loops()
	if sine_interpolation:
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)


# Get the collision shapes
func get_collision_shapes() -> Array[CollisionShape3D]:
	var shapes: Array[CollisionShape3D]
	
	for child in get_children():
		if child is CollisionShape3D:
			shapes.append(child)
	
	if not shapes.is_empty():
		return shapes
	else:
		printerr("No CollisionShape3D is found in Node: " + get_parent().name + "/" + name)
	
	return []


# Set the collision shapes disability value
func disable_collision_shapes(collisions: Array[CollisionShape3D], enable: bool) -> void:
	if not collisions.is_empty():
		for shapes in collisions:
			shapes.disabled = enable


# Handles loop movement of the laser
func looping(destination: Node3D) -> void:
	# Tweening setup
	create_tweening()
	
	# Tweening movement
	tween.tween_property(self, "global_position", destination.global_position, duration/2.0)
	
	tween.tween_property(self, "global_position", global_position, duration/2.0)


# Do One-Shot attack when triggered
func oneshot_strike(destination: Node3D) -> void:
	# Tweening setup
	create_tweening()
	
	# Tweening movement
	tween.tween_property(self, "global_position", destination.global_position, duration)


func reset_laser() -> void:
	if triggerbox:
		visible = false
		disable_collision_shapes(collision_shapes, true)
	
	global_position = position_origin



# ------ SIGNAL ------

func _on_oneshot_attack(body: Node3D) -> void:
	if not triggered:
		triggered = true
		visible = true
		disable_collision_shapes(collision_shapes, false)
		
		await get_tree().create_timer(anticipation_duration).timeout
		
		oneshot_strike(end_position)
		
		await tween.finished
		await get_tree().create_timer(1.0).timeout
		
		triggered = false


func _on_looping_attack(body: Node3D) -> void:
	if not triggered:
		# Adjust settings
		triggered = true
		disable_collision_shapes(collision_shapes, false)
		visible = true
		
		# Do Action
		looping(end_position)


# Kills the Player when collide with the laser
func _on_laser_entered(body: Node3D) -> void:
	if body is Player:
		body.kill_self()
