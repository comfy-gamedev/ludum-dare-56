extends Camera2D

@export var y_min: float = 0.0
@export var y_max: float = 0.0

var _tween: Tween

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pan_up"):
		move_to(position.y - 3 * 16.0)
	elif event.is_action_pressed("pan_down"):
		move_to(position.y + 3 * 16.0)

func move_to(y: float) -> void:
	if _tween:
		_tween.kill()
	y = clampf(y, y_min, y_max)
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	_tween.tween_property(self, "position:y", y, 0.2)
