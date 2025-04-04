extends Node
class_name LevelFinisher_Handler


@export var next_level: PackedScene
@export var level_finisher_gui: LevelFinisher_GUI

var finished: bool = false



#func _ready() -> void:
	##var scene_root: GameSceneState = get_tree().get_current_scene()
	#pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_level") and finished and next_level:
		# ON-PROGRESS : Global scene switcher is under construction
		#Global.change_scene(next_level)
		printerr("Global scene switcher is under construction")



# ------ SUPPORTING FUNCTIONS ------

func level_finished() -> void:
	finished = true
	
	get_tree().set_pause(true)
	Global.set_global_condition("is_player_controllable", false)
	level_finisher_gui.visible = true
