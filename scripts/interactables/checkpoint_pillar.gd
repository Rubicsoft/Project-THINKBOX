extends StaticBody3D


@export var custom_position: Node3D

@onready var label = $Label3D
@onready var collected_sfx = $CollectedSFX


var player: CharacterBody3D

var prompt_msg: String = "Apply Checkpoint"
var is_obtained: bool = false

func _ready():
	label.visible = false
	player = Global.get_player()


func _on_interact() -> void:
	if not is_obtained and player:
		is_obtained = true
		node_reaction()
		if custom_position:
			Checkpoint.last_position = custom_position.global_position
			Checkpoint.last_rotation = custom_position.global_rotation
		else:
			Checkpoint.last_position = player.global_position
			Checkpoint.last_rotation = player.global_rotation


func node_reaction() -> void:
	label.visible = true
	prompt_msg = ""
	collected_sfx.play()
