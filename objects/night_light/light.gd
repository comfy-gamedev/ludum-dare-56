extends Node2D

@export var texture: Texture2D

var flicker: float = 1.0

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var r = get_parent().get_parent().radius * flicker
	draw_texture_rect(texture, Rect2(-r, -r, r*2, r*2), false)
