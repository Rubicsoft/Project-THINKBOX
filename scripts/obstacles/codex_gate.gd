extends StaticBody3D

@export_range(1, 20, 1) var max_codex: int = 5
@export var codexcount: Label3D


# Variables
var gate_granted: bool = false:
	set(new_value):
		if new_value != gate_granted:
			gate_granted = new_value
			gate_open(new_value)

var collision_obj: Array[CollisionShape3D]



func _ready() -> void:
	collision_obj = get_collision_shapes()
	
	# Check if CodexCount label is defined or not
	if not codexcount:
		printerr("No CodexCount Label is found in Node: " + get_parent().name + "/" + name)


func _process(delta: float) -> void:
	# CodexCount label based on the collected codex and the maximum codex
	if codexcount:
		codexcount.text = str(Global.get_global_state("codex_collected")) + "/" + str(max_codex)
	
	# Open the gate when the desired codex is fulfilled
	if Global.get_global_state("codex_collected") >= max_codex:
		gate_granted = true



# ------ SUPPORTING FUNCTIONS ------

# Get the collision shapes of the codex gate
func get_collision_shapes() -> Array[CollisionShape3D]:
	var shapes: Array[CollisionShape3D]
	
	for child in get_children():
		if child is CollisionShape3D:
			shapes.append(child)
	
	return shapes


# Open the gate when granted
func gate_open(open: bool) -> void:
	for shapes in collision_obj:
		shapes.disabled = open
