extends Control

@onready var start_game_button: Button = %StartGameButton
@onready var how_to_play_button: Button = %HowToPlayButton
@onready var options_button: Button = %OptionsButton


func _ready() -> void:
	start_game_button.grab_focus()
	MusicMan.music(preload("res://assests/Music/battle-time.ogg"), 0.5, 0.0)


func _on_start_game_button_pressed() -> void:
	Globals.reset()
	Globals.upgrades_queued = [Enums.Upgrades.STARTER, Enums.Upgrades.FORTIFICATIONS, Enums.Upgrades.BLUEPRINTS]
	SceneGirl.change_scene("res://scenes/upgrade_screen/upgrade_screen.tscn")


func _on_how_to_play_button_pressed() -> void:
	MusicMan.music(preload("res://assests/Music/building-time.ogg"), 0.5, 0.0)
	SceneGirl.change_scene("res://scenes/help_screen/help_scene.tscn")

func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_start_game_button_mouse_entered() -> void:
	start_game_button.grab_focus()


func _on_how_to_play_button_mouse_entered() -> void:
	how_to_play_button.grab_focus()


func _on_options_button_mouse_entered() -> void:
	options_button.grab_focus()
