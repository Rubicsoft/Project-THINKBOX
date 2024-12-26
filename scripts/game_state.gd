extends Node3D

@export var opening_cutscene: AnimationPlayer

func _ready() -> void:
	# Make the mouse invisible and centered when in gameplay
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Play the opening cutscene
	if opening_cutscene:
		opening_cutscene.play("opening")
		Global.is_player_controllable = false
	# Call the AnimationPlayer signal when it's finished
	if opening_cutscene:
		opening_cutscene.connect("animation_finished", Callable(self, "_on_opening_cutscene_finished"))

func _process(delta) -> void:
	print("Player death count : " + str(Global.get_value("death_count")))
	print("Codex collected : " + str(Global.get_value("codex_collected")))
	

func _on_opening_cutscene_finished(anim_name: StringName) -> void:
	Global.is_player_controllable = true
