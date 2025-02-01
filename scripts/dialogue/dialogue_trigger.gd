extends Area3D


func _on_trigger_entered(body: Node3D) -> void:
	print("PLEASE SAY SOMETHING :v")
	
	for i in range(get_child_count()):
		if get_child(i) is DialogHandler:
			print(get_child(i).dialogue_dict)
