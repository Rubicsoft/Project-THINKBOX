extends StaticBody3D

@export var player: CharacterBody3D
@onready var label = $Label3D
@onready var collected_sfx = $CollectedSFX

var prompt_msg: String = "Checkpoint\n[COLLECT]"
var is_obtained: bool = false

func _ready():
	label.visible = false

func interact() -> void:
	if not is_obtained:
		is_obtained = true
		node_reaction()
		Checkpoint.last_position = player.global_position
		Checkpoint.last_rotation = player.global_rotation
		#print("Player last position : " + str(Checkpoint.last_position))
		#print("Player last rotation : " + str(rad_to_deg(Checkpoint.last_rotation.y)))

func node_reaction() -> void:
	label.visible = true
	prompt_msg = ""
	collected_sfx.play()
