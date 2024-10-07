extends Node2D


func _on_ui_canvas_layer_upgrade_done() -> void:
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")
