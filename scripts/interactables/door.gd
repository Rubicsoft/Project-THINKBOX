extends Node3D

@onready var animation = $AnimatableBody3D/AnimationPlayer

var toggle: bool = false
var is_interactable: bool = true

func _input(event):
	if event.is_action_pressed("interact"):
		toggle = not toggle
		if toggle == false:
			animation.play("door_close")
		if toggle == true:
			animation.play("door_open")

func interact():
	if is_interactable == true:
		is_interactable = false
		toggle = not toggle
		if toggle == false:
			animation.play("door_close")
		if toggle == true:
			animation.play("door_open")
		get_tree().create_timer(1.0, false).timeout
		is_interactable = true
