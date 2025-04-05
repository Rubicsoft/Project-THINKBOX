extends Node3D

## Activate the World Killzone
@export var active: bool = true

@export_category("Node Removal")
## Remove the children of the given array of parents when below the World Killzone
@export var parent_node_array: Array[Node3D]


var player: Player



func _ready() -> void:
	player = Global.get_player()


func _process(_delta: float) -> void:
	if active:
		# Kills the Player when below the Killzone
		if player and (player.global_position.y < global_position.y):
			player.kill_self()
		
		
		# Delete object when below the Killzone
		## Parent based
		if not parent_node_array.is_empty():
			for parent in parent_node_array:
				for child_node in parent.get_children():
					remove_node(child_node)



# ------ SUPPORTING FUNCTIONS ------

# Remove a defined node when below the Killzone
func remove_node(node: Node3D) -> void:
	if node.global_position.y < global_position.y:
		node.queue_free()
		
		await get_tree().process_frame
