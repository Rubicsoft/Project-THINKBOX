extends Node

@export_category("Cutscene Resources")
@export var cutscene: AnimationPlayer
@export var cutscene_name: String

@export_category("Cutscene Adjustment")
@export var play_at_beginning: bool = false
@export var player_controlability: bool = false
@export var non_pausable: bool = true
@export var hide_hud: bool = true
@export var skipable: bool = false


var player: Player



func _ready() -> void:
	player = Global.get_player()
	
	if cutscene:
		# Disable all cameras unless they're triggered to play
		for child in cutscene.get_children():
			if child is Camera3D:
				child.current = false
	else:
		printerr("Please assign AnimationPlayer node as the cutscene")

	
	# Check if the cutscene plays at beginning or triggered by Area3D
	if play_at_beginning:
		# Play in the beginning
		play_cutscene()
	
	elif get_parent() is Area3D:
		# Play cutscene when triggered
		get_parent().connect("body_entered", Callable(self, "_on_hitbox_triggered"))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_cutscene") and Global.get_global_condition("is_playing_cutscene") and skipable:
		skip_cutscene()


# ------ SUPPORTING FUNCTIONS ------

# Play the cutscene
func play_cutscene() -> void:
	if cutscene:
		cutscene.play(cutscene_name)
		
		Global.set_global_condition("is_playing_cutscene", true)
		
		if not player_controlability:
			Global.set_global_condition("is_player_controllable", false)
			player.velocity = Vector3.ZERO
		
		if non_pausable:
			Global.set_global_condition("is_pausable", false)
		
		if hide_hud:
			Global.set_global_condition("show_hud", false)
		
		await cutscene.animation_finished
		cutscene_finished()


# Action when the cutscene is finished
func cutscene_finished() -> void:
	print("CUTSCENE DONE")
	
	revert_global_condition_property("is_playing_cutscene")
	revert_global_condition_property("is_player_controllable", not player_controlability)
	revert_global_condition_property("is_pausable", non_pausable)
	revert_global_condition_property("show_hud", hide_hud)


# Skip the cutscene
func skip_cutscene() -> void:
	if cutscene:
		## Transition Effect (Fade-Out)
		# Create a fadebox
		var fadebox: ColorRect = ColorRect.new()
		fadebox.z_index = 5
		fadebox.set_anchors_preset(Control.PRESET_FULL_RECT)
		fadebox.color = Color.BLACK
		fadebox.modulate = Color.TRANSPARENT
		add_child(fadebox)
		
		# Tween the fadebox modulate property
		var tween: Tween = get_tree().create_tween()
		await tween.tween_property(fadebox, "modulate", Color.WHITE, 1.0).finished
		
		
		## Stop Cutscene
		# If there is any existing cutscene is playing cutscene, stop the current cutscene
		if cutscene.is_playing():
			cutscene.stop()
		# Reset the cutscene
		cutscene.play("RESET")
		
		## Delete the fadebox and the tweener
		tween.kill()
		fadebox.queue_free()


# Reset the property
## NOTE : This function has to be placed on global.gd script, considering there is a stashed commit working
## for Global Scene Switcher
func revert_global_condition_property(global_property: String, condition: bool = true) -> void:
	if condition:
		Global.set_global_condition(global_property, not Global.get_global_condition(global_property))



# ------ SIGNAL ------

func _on_hitbox_triggered(body: Node3D) -> void:
	if body is Player:
		play_cutscene()
