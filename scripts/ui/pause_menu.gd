extends Control

@export var camera_fx: Control

@onready var anim: AnimationPlayer = $AnimationPlayer


var pausemenu_visibility: bool = false
var bgm_normal_volume: float

const BGM_PAUSED_VOLUME = -10.0
const BGM_PAUSE_SMOOTHNESS = 5.0

func _ready() -> void:
	bgm_normal_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM"))

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


func pause_game() -> void:
	get_tree().paused = true
	pausemenu_visibility = true
	anim.play("pause_popup")

func resume_game() -> void:
	get_tree().paused = false


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_resume_btn_pressed() -> void:
	anim.play_backwards("pause_popup")
	pausemenu_visibility = false
	get_tree().paused = false


func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	Global.reset_global()
	get_tree().reload_current_scene()


func _on_restart_checkpoint_btn_pressed() -> void:
	anim.play_backwards("pause_popup")
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
