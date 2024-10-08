extends Control


@onready var mesh_instance_3d: MeshInstance3D = $Node3D/MeshInstance3D

func _ready():
	MusicMan.music(preload("res://assests/Music/building-time.ogg"), 0.5, 0.0)

func _process(delta: float) -> void:
	mesh_instance_3d.material_override.uv1_offset.y -= delta * 0.01

func _on_restart_button_pressed() -> void:
	Globals.reset()
	Globals.upgrades_queued = [Enums.Upgrades.STARTER, Enums.Upgrades.FORTIFICATIONS, Enums.Upgrades.BLUEPRINTS]
	SceneGirl.change_scene("res://scenes/upgrade_screen/upgrade_screen.tscn")


func _on_mm_button_pressed() -> void:
	SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
