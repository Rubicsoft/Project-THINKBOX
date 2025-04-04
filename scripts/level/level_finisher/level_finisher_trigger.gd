extends Area3D

@export_range(1, 10, 0.1) var spin_speed: float = 5.0

@onready var model: CSGCombiner3D = $Model

var levelfinisher_handler: LevelFinisher_Handler


func _ready() -> void:
	model_spin(10.0 / spin_speed)
	
	for child in get_children():
		if child is LevelFinisher_Handler:
			levelfinisher_handler = child
	if not levelfinisher_handler:
		printerr("No LevelFinisher Handler node is defined on node: " + get_parent().name + "/" + name)


# Spin the finisher model
func model_spin(duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tween.set_loops()
	
	tween.tween_property(model, "rotation:z", deg_to_rad(-360.0), duration)
	tween.tween_property(model, "rotation:z", deg_to_rad(0.0), 0.0)


# ------ SIGNAL ------

func _on_level_finisher_entered(body: Node3D) -> void:
	if levelfinisher_handler:
		levelfinisher_handler.level_finished()
