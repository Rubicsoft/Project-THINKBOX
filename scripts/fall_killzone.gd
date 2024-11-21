extends Area3D

func _on_body_entered(body):
	print(body)
	if body is CharacterBody3D:
		Global.decrease_value("live_left")
		Checkpoint.respawn(body)
