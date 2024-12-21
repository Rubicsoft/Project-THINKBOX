extends Area3D

@onready var animation = $AnimationPlayer
@onready var pickup_sfx = $PickUp

func _on_body_entered(body):
	print("CODEX")
	animation.play("codex_pickup")
	pickup_sfx.play()
