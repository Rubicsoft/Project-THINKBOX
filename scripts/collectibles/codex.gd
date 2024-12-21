extends Area3D

@onready var animation = $AnimationPlayer

var is_pickable: bool = true


func _on_body_entered(body):
	if is_pickable:
		is_pickable = false
		print("CODEX")
		animation.play("codex_pickup")


func _on_animation_player_animation_finished(anim_name):
	queue_free()
