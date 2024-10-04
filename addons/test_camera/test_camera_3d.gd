extends Node3D

const ZOOM_STEP = 1.1
const MOUSE_SENSITIVITY = 0.01

@onready var camera_gimbal: Node3D = $CameraGimbal
@onready var camera: Camera3D = $CameraGimbal/Camera

var _tracking_mouse: bool = false

func _ready() -> void:
	var aabb := _get_scene_aabb()
	camera.position.z = aabb.get_longest_axis_size()
	camera_gimbal.rotation.y = TAU / 8.0
	camera_gimbal.rotation.x = -TAU / 16.0
	global_position = aabb.get_center()

func _process(delta: float) -> void:
	var aabb := _get_scene_aabb()
	global_position = aabb.get_center()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				_tracking_mouse = event.pressed
				return
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					camera.position.z /= ZOOM_STEP
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					camera.position.z *= ZOOM_STEP
	
	if _tracking_mouse:
		if event is InputEventMouseMotion:
			camera_gimbal.rotation.y += -MOUSE_SENSITIVITY * event.relative.x
			camera_gimbal.rotation.x += -MOUSE_SENSITIVITY * event.relative.y
			camera_gimbal.rotation.x = clampf(camera_gimbal.rotation.x, -TAU / 4.0, TAU / 4.0)


func _get_scene_aabb() -> AABB:
	var visual_instances := get_tree().root.find_children("*", "VisualInstance3D", true, false)
	
	var aabb: AABB
	
	for vi: VisualInstance3D in visual_instances:
		var vi_global_transform := vi.global_transform
		vi_global_transform.basis = Basis()
		var vi_aabb := vi_global_transform * vi.get_aabb()
		if not aabb:
			aabb = vi_aabb
		else:
			aabb = aabb.merge(vi_aabb)
	
	return aabb
