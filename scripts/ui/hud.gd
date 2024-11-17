extends Control

@export var interact_raycast: RayCast3D

@onready var collide_label = $CollideWith
@onready var frame_rate = $FrameRate
@onready var crosshair = $Control/Crosshair


func _process(delta):
	# Set only visible when the game is playing(not paused)
	visible = not get_tree().paused
	
	# Handle label for interactables
	collide_label.text = ""
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		#label.text = collider.name
		if collider.has_method("interact"):
			collide_label.text = collider.prompt_msg
	
	frame_rate.text = "FPS " + str(Engine.get_frames_per_second())
