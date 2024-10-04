extends Control

@onready var start_game_button: Button = %StartGameButton
@onready var how_to_play_button: Button = %HowToPlayButton
@onready var options_button: Button = %OptionsButton


func _ready() -> void:
	start_game_button.grab_focus()


func _on_start_game_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")


func _on_how_to_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_start_game_button_mouse_entered() -> void:
	start_game_button.grab_focus()


func _on_how_to_play_button_mouse_entered() -> void:
	how_to_play_button.grab_focus()


func _on_options_button_mouse_entered() -> void:
	options_button.grab_focus()
