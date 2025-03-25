extends Node3D


@export_multiline var guidebox_message: String = "Guidebox"
@export var visible_distance: float = 5.0

@onready var label: Label3D = $Label3D

var player: Player
var is_visible: bool = false
const fade_duration = 0.5



func _ready() -> void:
	player = Global.get_player()
	
	# Label Setup
	label.modulate.a = 0.0
	label.pixel_size = 0.002
	label.no_depth_test = true
	label.fixed_size = true


func _process(delta: float) -> void:
	label.text = guidebox_message
	if player:
		if Global.get_distance_3d(self, player) <= visible_distance:
			# Show label
			toggle_show(true)
		else:
			# Hide label
			toggle_show(false)


# ------ SUPPORTING FUNCTIONS ------

func toggle_show(visibility: bool) -> void:
	var tween = get_tree().create_tween()
	var target_opacity: float = 1.0 if visibility else 0.0
	
	tween.tween_property(label, "modulate:a", target_opacity, fade_duration)
	
