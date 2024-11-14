extends RayCast3D


func _ready():
	pass

func _input(event):
	if is_colliding():
		var hit_obj = get_collider()
		if hit_obj is Interactable and event.is_action_pressed("interact"):
			hit_obj.interact()
