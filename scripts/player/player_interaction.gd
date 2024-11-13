extends RayCast3D


func _ready():
	pass # Replace with function body.

func _input(event):
	pass
	#if event.is_action_pressed("interact"):
		#var collider = get_collider()
		#print(collider)
		#if collider != null:
			#print(collider)

func _process(delta):
	if is_colliding():
		var hit_obj = get_collider()
		if hit_obj.has_method("interact") and Input.is_action_pressed("interact"):
			hit_obj.interact()
			print("OPEN")
