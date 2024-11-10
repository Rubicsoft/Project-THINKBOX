extends Control

func _input(event):
	if event.is_action_pressed("esc") and !get_tree().paused:
		pause_game()

func _process(delta):
	visible = get_tree().paused
	match get_tree().paused:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_resume_btn_pressed():
	get_tree().paused = false
