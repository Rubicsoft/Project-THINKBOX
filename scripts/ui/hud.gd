extends Control

@export var interact_raycast: RayCast3D

@onready var collide_label = $CollideWith
@onready var frame_rate = $FrameRate
@onready var crosshair = $Crosshair_Pivot/Crosshair
#Healthbar
@onready var life_1 = $Health/Life1
@onready var life_2 = $Health/Life2
@onready var life_3 = $Health/Life3


func _process(delta) -> void:
	# Set only visible when the game is playing(not paused)
	visible = not get_tree().paused
	
	healthbar()
	crosshair.texture = preload("res://assets/img/crosshair.png")
	
	# Handle label for interactables
	collide_label.text = ""
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		#label.text = collider.name
		if collider.has_method("interact"):
			collide_label.text = collider.prompt_msg
			crosshair.texture = preload("res://assets/img/crosshair_hovered.png")
	
	frame_rate.text = "FPS " + str(Engine.get_frames_per_second())

func healthbar() -> void:
	match Global.get_value("life_left"):
		2:
			life_3.visible = false
		1:
			life_2.visible = false
