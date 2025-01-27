extends Node3D

@export var player: Player
@export var guidebox_message: String = "This is Guidebox"
@export var visible_distance: float = 5.0

@onready var label: Label3D = $Label3D

var is_visible: bool = false
const fade_duration = 0.5

func _process(delta: float) -> void:
	label.text = guidebox_message
	if player:
		if Global.get_distance_3d(self, player) <= visible_distance:
			# Show label
			toggle_show(true)
		else:
			# Hide label
			toggle_show(false)

func toggle_show(visibility: bool) -> void:
	var tween = get_tree().create_tween()
	var target_opacity: float = 1.0 if visibility else 0.0
	
	tween.tween_property(label, "modulate:a", target_opacity, fade_duration)
	
