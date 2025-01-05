extends Control

var gamescene: PackedScene = preload("res://scenes/main_level.tscn")

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_packed(gamescene)
