extends Node

@onready var sub_viewport: SubViewport = $SmoothPixelSubViewportContainer/SubViewport
@onready var smooth_pixel_sub_viewport_container: SubViewportContainer = $SmoothPixelSubViewportContainer

func _ready() -> void:
	sub_viewport.size = get_viewport().size + Vector2i(2, 2)
	SceneGirl.root = sub_viewport
	SceneGirl.current_scene = null
	if OS.has_feature("editor") and has_meta("test_scene"):
		SceneGirl.change_scene(get_meta("test_scene"))
	else:
		SceneGirl.change_scene("res://scenes/main_menu/main_menu.tscn")
