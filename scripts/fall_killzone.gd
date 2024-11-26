extends Area3D

func _on_body_entered(body):
	if body is CharacterBody3D:
		Global.decrease_value("life_left")
		Checkpoint.respawn(body)
		
