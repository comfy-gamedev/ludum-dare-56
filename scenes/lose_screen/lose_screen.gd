extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Globals.reset()
	SceneGirl.change_scene("res://scenes/main_gameplay/main_gameplay.tscn")


func _on_button_2_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
