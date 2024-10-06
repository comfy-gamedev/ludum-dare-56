extends Node2D

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, get_parent().get_parent().radius, Color.WHITE)
