extends Area3D

@onready var orb: MeshInstance3D = $Orb
@onready var pickup_anim: AnimationPlayer = $PickUp
@onready var timer: Timer = $Timer


@export_range(1.0, 10.0, 0.5) var spawn_time: float = 5.0


signal picked_changed(condition: bool)
var picked: bool = false:
	set(new_value):
		if picked != new_value:
			picked = new_value
			emit_signal("picked_changed", new_value)



func _process(delta: float) -> void:
	if Global.get_global_state("dash_orbs") == 0:
		picked = false


# SIGNAL

func _on_body_entered(body: Node3D) -> void:
	if body is Player and not picked:
		Global.increase_global_state("dash_orbs", 1)
		picked = true


func _on_picked(condition: bool) -> void:
	if condition:
		pickup_anim.play("pick_up")
		timer.start()
	else:
		pickup_anim.play("show_up")


func _on_timer_timeout() -> void:
	picked = false
