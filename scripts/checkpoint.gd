extends Node

var last_position: Vector3
var last_rotation: Vector3

func respawn(player: Player) -> void:
	player.global_position = last_position
	player.global_rotation = last_rotation
	after_dying_timer(player)

func after_dying_timer(player: Player) -> void:
	player.after_dying.start()
	Global.is_player_controllable = false
	Global.set_global_condition("is_player_controllable", false)
	player.velocity = Vector3.ZERO
