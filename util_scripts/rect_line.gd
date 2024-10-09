@tool
class_name RectLine
extends RefCounted

static func draw(node: CanvasItem, from: Vector2, to: Vector2, color: Color, thiccness: float = -1.0) -> void:
	if thiccness == -1.0:
		thiccness = 1.0
	var orig = from
	var len = from.distance_to(to)
	var rot = from.angle_to_point(to)
	var rect = Rect2(
		Vector2(0, roundf(-thiccness / 2.0)),
		Vector2(len, thiccness))
	node.draw_set_transform(orig, rot, Vector2.ONE)
	node.draw_rect(rect, color)
	node.draw_set_transform_matrix(Transform2D.IDENTITY)
