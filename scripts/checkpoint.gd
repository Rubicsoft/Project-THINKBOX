extends Node

var last_position: Vector3
var last_rotation: Vector3

func respawn(player: CharacterBody3D) -> void:
	player.global_position = last_position
	player.global_rotation = last_rotation
