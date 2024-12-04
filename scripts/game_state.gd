extends Node3D

@export var opening_cutscene: AnimationPlayer

func _ready() -> void:
	if opening_cutscene:
		opening_cutscene.connect("animation_finished", Callable(self, "_on_opening_cutscene_finished"))
	# Make the mouse invisible and centered when in gameplay
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if opening_cutscene:
		opening_cutscene.play()
		Global.is_player_controllable = false

func _process(delta) -> void:
	print("Player life left " + str(Global.get_value("life_left")))
	if Global.get_value("life_left") <= 0:
		get_tree().quit()

func _on_opening_cutscene_finished(anim_name: StringName) -> void:
	Global.is_player_controllable = true
