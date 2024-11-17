extends RayCast3D


func _input(event):
	# Check if the player collide with interactables and interact them
	if is_colliding():
		var hit_obj = get_collider()
		if hit_obj.has_method("interact") and event.is_action_pressed("interact"):
			hit_obj.interact()
