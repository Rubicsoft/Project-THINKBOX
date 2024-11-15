extends RayCast3D


func _input(event):
	# Check if the player collide with interactables and interact them
	if is_colliding():
		var hit_obj = get_collider()
		print("Type of Collide object : ", typeof(hit_obj))
		if hit_obj is Interactable and event.is_action_pressed("interact"):
			hit_obj.interact()
