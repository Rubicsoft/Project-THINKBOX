extends Area3D

var player: CharacterBody3D
var is_climbing: bool = false

const CLIMB_SPEED = 4.5
const CLIMB_SMOOTHNESS = 12.5

func _physics_process(delta):
	if is_climbing and Input.is_action_pressed("move_foreward"):
		player.velocity.y = CLIMB_SPEED

func _on_body_entered(body) -> void:
	if body is Player:
		player = body
		is_climbing = true

func _on_body_exited(body):
	is_climbing = false
