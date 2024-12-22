extends Area3D

@onready var boing_sfx = $BoingSFX

@export_range(1.0, 20.0, 0.1) var JUMP_FORCE: float = 10.0

func make_jump(player: CharacterBody3D) -> void:
	if player.velocity.y:
		player.velocity.y = JUMP_FORCE
		player.jump(false) # Play jump effect
		#boing_sfx.play()
		print("BOUNCE")

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		make_jump(body)
