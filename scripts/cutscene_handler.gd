extends Node

@export var cutscene: AnimationPlayer
@export var cutscene_name: String
@export var player_controlability: bool = false
@export var pausable: bool = true
@export var hide_hud: bool = true
@export var skipable: bool = false


func _ready() -> void:
	if cutscene:
		cutscene.connect("animation_finished", Callable(self, "_on_cutscene_finished"))
		
		for i in range(cutscene.get_child_count()):
			if get_child(i) is Camera3D:
				# Disable all cameras unless they're triggered to play
				get_child(i).current = false
	else:
		printerr("Please assign cutscene")
	
	var parent: Node = get_parent()
	if parent is Area3D:
		# Play cutscene when triggered
		parent.connect("body_entered", Callable(self, "_on_hitbox_triggered"))
	elif (parent is GameSceneState):
		# Play in the beginning
		play_cutscene()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_cutscene") and Global.is_playing_cutscene and skipable:
		skip_cutscene()


func play_cutscene() -> void:
	if cutscene:
		cutscene.play(cutscene_name)
		if not player_controlability:
			Global.is_player_controllable = false
		if pausable:
			Global.is_pausable = false
		if hide_hud:
			Global.is_playing_cutscene = true


func skip_cutscene() -> void:
	if cutscene:
		cutscene.play("RESET")


func _on_cutscene_finished(_anim_name: StringName) -> void:
	if not player_controlability:
		Global.is_player_controllable = true
	if pausable:
		Global.is_pausable = true
	if hide_hud:
		Global.is_playing_cutscene = false


func _on_hitbox_triggered() -> void:
	play_cutscene()
	print("PLAY CUTSCENE WOYY!")
