extends Area3D


@export var player: CharacterBody3D
@export var activate_above_player: bool

var killzone_active: bool = true


func _process(delta) -> void:
	if player:
		if activate_above_player:
			if player.global_position.y > global_position.y:
				killzone_active = true
			else:
				killzone_active = false
	else :
		printerr("Player node is not detected")


func _on_body_entered(body) -> void:
	if player:
		if (body == player) and killzone_active:
			player.kill_self()
	else:
		printerr("Player node is not detected")
