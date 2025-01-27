extends Control

var gamescene: PackedScene = preload("res://scenes/levels/level_1.tscn")

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_packed(gamescene)
