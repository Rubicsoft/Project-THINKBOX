extends Area3D

func make_jump(player: CharacterBody3D) -> void:
	player.velocity.y = 10.0

func _on_body_entered(body: Node3D) -> void:
	print("Player collide")
	if body is CharacterBody3D:
		make_jump(body)
