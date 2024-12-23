extends Area3D


@export var player: CharacterBody3D
@export var activate_above_player: bool
@export var above_minimum: Node3D

var killzone_active: bool = true


func _process(delta) -> void:
	var minimum_height: float
	
	if player:
		if activate_above_player:
			# Custom minimum height
			# Useful for high plaform
			minimum_height = set_minimum_height()
			
			if player.global_position.y > minimum_height:
				killzone_active = true
			else:
				killzone_active = false
	else :
		printerr("Player node is not detected")


func set_minimum_height() -> float:
	if above_minimum:
		return above_minimum.global_position.y
	else:
		return global_position.y


func _on_body_entered(body) -> void:
	if player:
		if (body == player) and killzone_active:
			player.kill_self()
	else:
		printerr("Player node is not detected")
