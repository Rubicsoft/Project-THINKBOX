extends Area3D

func _on_body_entered(body):
	if body is Player:
		# Check the player fall speed to makesure the health decreased
		if not body.velocity.y < -body.FALL_DAMAGE_SPEED:
			Global.decrease_value("life_left")
			Checkpoint.respawn(body)
		else:
			# if it does, don't decrease the live left value
			# Because it's already player fall kill task
			Checkpoint.respawn(body)
		
