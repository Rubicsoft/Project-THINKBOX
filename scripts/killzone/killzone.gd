extends Area3D


@export var active: bool = true
@export var player: CharacterBody3D
@export var activate_above_player: bool

var killzone_standby: bool = true


func _process(delta) -> void:
	if player:
		if activate_above_player:
			if player.global_position.y > global_position.y:
				killzone_standby = true
			else:
				killzone_standby = false
	else :
		printerr("Player node is not detected")


func _on_body_entered(body) -> void:
	if player:
		if active and (body == player) and killzone_standby:
			player.kill_self()
	else:
		printerr("Player node is not detected")
