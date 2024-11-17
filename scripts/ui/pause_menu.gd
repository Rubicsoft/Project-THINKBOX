extends Control

var bgm_normal_volume: float

const BGM_PAUSED_VOLUME = -10.0
const BGM_PAUSE_SMOOTHNESS = 5.0

func _ready() -> void:
	bgm_normal_volume = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM"))

func _input(event) -> void:
	if event.is_action_pressed("esc") and not get_tree().paused:
		pause_game()

func _process(_delta) -> void:
	visible = get_tree().paused
	match get_tree().paused:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), lerp(bgm_normal_volume, BGM_PAUSED_VOLUME, BGM_PAUSE_SMOOTHNESS * delta))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), BGM_PAUSED_VOLUME)
		false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), lerp(BGM_PAUSED_VOLUME, bgm_normal_volume, BGM_PAUSE_SMOOTHNESS * delta))
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), bgm_normal_volume)

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_resume_btn_pressed():
	get_tree().paused = false

func _on_restart_btn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
