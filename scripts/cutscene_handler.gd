extends Node

@export var cutscene: AnimationPlayer
@export var player_controlability: bool = false

func _ready() -> void:
	for i in range(cutscene.get_child_count()):
		if get_child(i) is Camera3D:
			# Make all cameras aren't current unless they're played
			get_child(i).current = false
	
	var parent: Node = get_parent()
	if parent is Area3D:
		# Play cutscene when trigerred
		pass
	elif (parent is GameSceneLogic) or (parent is Node3D):
		# Play in the beginning
		pass

func play_cutscene() -> void:
	pass
