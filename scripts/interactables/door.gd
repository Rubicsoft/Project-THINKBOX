extends AnimatableBody3D
class_name Interactable

@onready var animation = $AnimationPlayer
var prompt_msg = "Door"

var toggle: bool = false
var is_interactable: bool = true

func _process(delta):
	match toggle:
		true:
			prompt_msg = "Door\n[CLOSE]"
		false:
			prompt_msg = "Door\n[OPEN]"

func interact():
	if is_interactable == true:
		is_interactable = false
		toggle = not toggle
		if toggle == false:
			animation.play("door_close")
		if toggle == true:
			animation.play("door_open")

func _on_animation_player_animation_finished(anim_name):
	is_interactable = true
