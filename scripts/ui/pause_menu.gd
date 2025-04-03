extends Control


@export var camera_fx: Control

var pausemenu_visibility: bool = false
var bgm_normal_volume: float
var menu_tween: Tween

const BGM_PAUSED_VOLUME = -10.0
const BGM_PAUSE_SMOOTHNESS = 5.0



func _ready() -> void:
	bgm_normal_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM"))
	
	# ON PROGRESS : There are some error to the Tweener
	menu_tween = create_tween()
	#menu_tween.bind_node(self)


func _input(event) -> void:
	if event.is_action_pressed("esc") and not get_tree().paused and Global.get_global_condition("is_pausable"):
		pause_game()


func _process(_delta) -> void:
	visible = pausemenu_visibility
	match get_tree().paused:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), BGM_PAUSED_VOLUME)
		false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), bgm_normal_volume)



# ------ SUPPORTING FUNCTIONS ------

# Pause the game
func pause_game() -> void:
	get_tree().paused = true
	pausemenu_visibility = true
	
	# ON PROGRESS : Error to the Tweener
	#modulate = Color.TRANSPARENT
	#menu_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
	#get_tree().create_tween().tween_property(self, "modulate", Color.WHITE, 0.5)
	modulate = Color.WHITE


# Resume the game
func resume_game() -> void:
	get_tree().paused = false
	#visible = false
	modulate = Color.TRANSPARENT
	pausemenu_visibility = false



# ------ SIGNALS ------

func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_resume_btn_pressed() -> void:
	#pausemenu_visibility = false
	#get_tree().paused = false
	resume_game()


func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	Global.reset_global()
	get_tree().reload_current_scene()


func _on_restart_checkpoint_btn_pressed() -> void:
	pausemenu_visibility = false
	
	var parent: Node = get_parent()
	if parent is Player:
		Checkpoint.respawn(parent)
		Global.increase_global_state("death_count", 1)
		resume_game()
		if camera_fx:
			camera_fx.play_effect("glitch_fadeout", false)
	else:
		printerr("No Player node inserted")


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
