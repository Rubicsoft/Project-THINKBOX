extends Control

@export var interact_raycast: RayCast3D
@onready var label = $Label

func _ready():
	pass # Replace with function body.

func _process(delta):
	label.text = ""
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		#label.text = collider.name
		if collider is Interactable:
			label.text = collider.prompt_msg
