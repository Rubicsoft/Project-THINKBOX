extends RigidBody3D

@export var prompt_msg: String = "You sucks"

@onready var animation = $AnimationPlayer

func interact() -> void:
	animation.play("collected")

func add_key() -> void:
	Global.set_state("square_key", Global.get_value("square_key") + 1)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
