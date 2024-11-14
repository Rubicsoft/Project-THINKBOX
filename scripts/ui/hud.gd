extends Control

@export var interact_raycast: RayCast3D
@onready var collide_label = $CollideWith
@onready var frame_rate = $FrameRate


func _ready():
	pass # Replace with function body.

func _process(delta):
	collide_label.text = ""
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		#label.text = collider.name
		if collider is Interactable:
			collide_label.text = collider.prompt_msg
	
	frame_rate.text = "FPS " + str(Engine.get_frames_per_second())
