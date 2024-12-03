extends Area3D

@export var JUMP_FORCE: float = 10.0

func make_jump(player: CharacterBody3D) -> void:
	print("BOUNCE")
	if player.velocity.y:
		player.velocity.y = JUMP_FORCE

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		make_jump(body)
