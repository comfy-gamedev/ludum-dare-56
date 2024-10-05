extends Node
## Adds a simple controllable camera when running scenes in isolation.
##
## When the project is run, if the initial scene has no camera, a test camera is added.
##
## If any 3D nodes are detected, the 3D test camera is used.
## Otherwise, the 2D test camera is used.
##
## The 3D camera automatically centers itself on the visual objects in the scene.
## The mouse wheel can be used to zoom in and out,
## and middle click can be held to orbit the camera around the scene.
##
## The 2D camera has similar controls, but pans instead of orbits.
## It does not follow the visual objects in the scene.

const TEST_CAMERA_2D = "res://addons/test_camera/test_camera_2d.tscn"
const TEST_CAMERA_3D = "res://addons/test_camera/test_camera_3d.tscn"

func _ready():
	if OS.has_feature("template"):
		return
	
	await get_tree().process_frame
	
	if get_viewport().get_camera_3d() != null:
		return
	
	if get_viewport().get_camera_2d() != null:
		return
	
	var visual_instances := get_tree().root.find_children("*", "VisualInstance3D", true, false)
	
	if not visual_instances.is_empty():
		get_tree().root.add_child(load(TEST_CAMERA_3D).instantiate())
		return
	
	if get_tree().current_scene.get_meta("test_camera", "") != &"disabled":
		get_tree().root.add_child(load(TEST_CAMERA_2D).instantiate())
	
