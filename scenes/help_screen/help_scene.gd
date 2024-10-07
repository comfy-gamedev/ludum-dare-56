extends Control

func _on_button_pressed() -> void:
	MusicMan.music(preload("res://assests/Music/battle-time.ogg"), 0.5)
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
