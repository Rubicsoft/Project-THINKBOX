extends Area3D

func _on_body_entered(body):
	if body is Player:
		# Just respawn the Player without draining its live left
		Checkpoint.respawn(body)
		
