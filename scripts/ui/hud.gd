extends Control

@export var interact_raycast: RayCast3D
@export var crosshair_texture: Texture2D
@export var crosshair_hovered_texture: Texture2D

@onready var collide_label = $CollideWith
@onready var frame_rate = $FrameRate
@onready var crosshair = $Crosshair_Pivot/Crosshair
@onready var death_count: Label = $DeathCount
@onready var codex_collected: Label = $CodexCollected


func _process(delta) -> void:
	# Visibility based on 'show_hud' global variable and process pause
	visible = Global.get_global_condition("show_hud") and (not get_tree().paused)
	
	crosshair.texture = crosshair_texture
	crosshair.visible = GameSettings.enable_crosshair
	
	death_count.text = str(Global.get_global_state("death_count"))
	codex_collected.text = str(Global.get_global_state("codex_collected"))
	
	# Handle label for interactables
	collide_label.text = ""
	if interact_raycast.is_colliding():
		var collider = interact_raycast.get_collider()
		#label.text = collider.name
		if collider.has_method("_on_interact"):
			collide_label.text = collider.prompt_msg
			crosshair.texture = crosshair_hovered_texture
	
	frame_rate.text = "FPS " + str(Engine.get_frames_per_second())
