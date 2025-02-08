extends Area3D


@export_range(1.0, 10.0, 0.5) var spawn_time: float = 4.0

var picked: bool = false


func _process(delta: float) -> void:
	if Global.get_global_state("dash_orbs") == 0:
		picked = false
	if picked:
		await get_tree().create_timer(spawn_time).timeout
		picked = false


func _on_body_entered(body: Node3D) -> void:
	if body is Player and not picked:
		Global.increase_value("dash_orbs")
		Global.increase_global_state("dash_orbs", 1)
		picked = true
