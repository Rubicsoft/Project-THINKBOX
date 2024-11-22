extends Area3D

func _on_body_entered(body):
	print(body)
	if body is CharacterBody3D:
		Global.decrease_value("life_left")
		Checkpoint.respawn(body)
	if body.collision_layer & 1:
		print(body.name)
		
