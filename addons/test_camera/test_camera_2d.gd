extends Camera2D

const ZOOM_STEP = 1.5
const MOUSE_SENSITIVITY = 1.0

var _tracking_mouse: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				_tracking_mouse = event.pressed
				return
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					zoom *= ZOOM_STEP
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					zoom /= ZOOM_STEP
	
	if _tracking_mouse:
		if event is InputEventMouseMotion:
			position += -MOUSE_SENSITIVITY * event.relative / zoom
