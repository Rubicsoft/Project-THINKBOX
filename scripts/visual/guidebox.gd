extends Node3D

@export var player: Player
@export var guidebox_message: String = "This is Guidebox"
@export var visible_distance: float = 5.0

@onready var label: Label3D = $Label3D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	label.text = guidebox_message
	if player:
		#print("Distance" + str(Global.get_distance_3d(self, player)))
		if Global.get_distance_3d(self, player) <= visible_distance:
			visible = true
			#animation.play("guidebox_show")
		else:
			visible = false
