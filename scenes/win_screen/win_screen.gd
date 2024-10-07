extends Control

@onready var mesh_instance_3d: MeshInstance3D = $Node3D/MeshInstance3D

func _ready():
	MusicMan.music(preload("res://assests/Music/battle-time.ogg"), 0.5)

func _process(delta: float) -> void:
	mesh_instance_3d.material_override.uv1_offset.y -= delta * 0.05


func _on_button_pressed() -> void:
	Globals.upgrades_queued = [Enums.Upgrades.ANYTHING, Enums.Upgrades.ANYTHING]
	SceneGirl.change_scene("res://scenes/upgrade_screen/upgrade_screen.tscn")


func _on_button_2_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
