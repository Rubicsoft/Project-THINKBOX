extends Area3D

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_body_entered(body):
	get_tree().reload_current_scene()
