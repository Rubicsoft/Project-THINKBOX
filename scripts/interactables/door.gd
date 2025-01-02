extends AnimatableBody3D


@onready var animation = $AnimationPlayer
var prompt_msg = "Door"

var toggle: bool = false
var is_interactable: bool = true

func _process(delta):
	match toggle:
		true:
			prompt_msg = "Wooden Door\n[CLOSE]"
		false:
			prompt_msg = "Wooden Door\n[OPEN]"

func _on_interact():
	var handle_position: String = get_parent().handle_position
	if is_interactable == true:
		is_interactable = false
		toggle = not toggle
		if toggle == false:
			if handle_position == "Left":
				animation.play("door_close_left_handle")
			elif handle_position == "Right":
				animation.play("door_close_right_handle")
		if toggle == true:
			if handle_position == "Left":
				animation.play("door_open_left_handle")
			elif handle_position == "Right":
				animation.play("door_open_right_handle")

func _on_animation_player_animation_finished(anim_name):
	is_interactable = true
