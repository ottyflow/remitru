extends Control
class_name MainMenu

## Main Menu Script
##
## Handles the initial screen of the game.

func _ready() -> void:
	# Connect buttons dynamically if they exist, or they can be connected via editor.
	# Here we assume a simple structure.
	var start_btn = $VBoxContainer/StartButton
	var load_btn = $VBoxContainer/LoadButton
	var exit_btn = $VBoxContainer/ExitButton
	
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	if load_btn:
		load_btn.pressed.connect(_on_load_pressed)
	if exit_btn:
		exit_btn.pressed.connect(_on_exit_pressed)

func _on_start_pressed() -> void:
	# Load the main game scene
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_load_pressed() -> void:
	print("Load Game not implemented yet.")
	# Placeholder logic

func _on_exit_pressed() -> void:
	get_tree().quit()
