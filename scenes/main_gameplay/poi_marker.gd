@tool
class_name PoiMarker
extends Marker2D

enum Kind {
	BLUE_CASTLE,
	RED_CASTLE,
	OBJECTIVE,
}

@export var kind: Kind: set = set_kind

func _ready() -> void:
	if Engine.is_editor_hint():
		set_notify_local_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_LOCAL_TRANSFORM_CHANGED:
		set_notify_local_transform(false)
		position = position.snapped(GridManager.CELL_SIZE)
		set_notify_local_transform(true)

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	var text: String = Kind.find_key(kind)
	var theme := preload("res://game_ui_theme.tres")
	var font := theme.get_font("font", "Label")
	var text_size := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, 19)
	draw_rect(Rect2(Vector2(0, -text_size.y), text_size).grow(1), Color.BLACK)
	draw_string(font, Vector2.ZERO, text, HORIZONTAL_ALIGNMENT_LEFT, -1, 19)

func set_kind(v: Kind) -> void:
	if kind == v: return
	kind = v
	queue_redraw()
