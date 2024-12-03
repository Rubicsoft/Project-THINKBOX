extends Area3D

func _on_body_entered(body):
	if body is Player:
		if not body.velocity.y < -body.FALL_DAMAGE_SPEED:
			Global.decrease_value("life_left")
			Checkpoint.respawn(body)
		else:
			Checkpoint.respawn(body)
		
