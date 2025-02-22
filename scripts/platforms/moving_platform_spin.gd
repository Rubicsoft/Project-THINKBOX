extends AnimatableBody3D
class_name FloatingPlatformSpin


@export var player: Player
@export_range(0.1, 10.0, 0.1) var visible_distance: float = 5.0

@onready var showup_anim: AnimationPlayer = $ShowUp


# Showup variable has a signal when its value changed
signal showup_changed(value: bool)
var showup: bool = false:
	set(new_value):
		if showup != new_value:
			showup = new_value
			emit_signal("showup_changed", new_value)



func _process(_delta: float) -> void:
	if player:
		showup = true if Global.get_distance_3d(self, player) < 5.0 else false
	else:
		printerr("Please insert Player Node for SpinningPlatform")


# SIGNAL

func _on_showup_changed(value: bool) -> void:
	if value:
		showup_anim.play("show_up")
	else:
		showup_anim.play("hide_up")
