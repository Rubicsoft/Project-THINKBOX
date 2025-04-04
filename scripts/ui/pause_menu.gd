extends Control


@export var camera_fx: Control

var pausemenu_visibility: bool = false
var bgm_normal_volume: float
var menu_tween: Tween

const BGM_PAUSED_VOLUME = -10.0
const BGM_PAUSE_SMOOTHNESS = 5.0
const fade_duration: float = 0.1



func _ready() -> void:
	bgm_normal_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM"))


func _input(event) -> void:
	# When PAUSE button is pressed, toggle the PauseMenu
	if event.is_action_pressed("esc") and Global.get_global_condition("is_pausable"):
		match get_tree().paused:
			true:
				resume_game()
			false:
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
	
	gui_fade(true, menu_tween, self, fade_duration)


# Resume the game
func resume_game() -> void:
	get_tree().paused = false
	
	await gui_fade(false, menu_tween, self, fade_duration).finished
	
	pausemenu_visibility = false


# Fade in/out to the GUI
func gui_fade(fade_in: bool, tween: Tween, gui_node: Control, duration: float) -> Tween:
	tween = get_tree().create_tween()
	tween.set_ignore_time_scale()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	match fade_in:
		true:
			gui_node.modulate = Color.TRANSPARENT
			tween.tween_property(gui_node, "modulate", Color.WHITE, duration)
		
		false:
			gui_node.modulate = Color.WHITE
			tween.tween_property(gui_node, "modulate", Color.TRANSPARENT, duration)
	
	return tween



# ------ SIGNALS ------

# Quit to Desktop
func _on_quit_btn_pressed() -> void:
	get_tree().quit()


# Resume game
func _on_resume_btn_pressed() -> void:
	resume_game()


# Restart level
func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	Global.reset_global()
	get_tree().reload_current_scene()


# Restart from Checkpoint
func _on_restart_checkpoint_btn_pressed() -> void:
	resume_game()
	
	var parent: Node = get_parent()
	if parent is Player:
		Checkpoint.respawn(parent)
		Global.increase_global_state("death_count", 1)
		resume_game()
		if camera_fx:
			camera_fx.play_effect("glitch_fadeout", false)
	else:
		printerr("No Player node inserted")


# Back to Main Menu
func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu_scene.tscn")
