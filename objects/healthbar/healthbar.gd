extends Node2D

@export var size = 16

var lastHealth
var health : float
var max_health : float

func _process(delta: float) -> void:
	health = get_parent().health
	if health != lastHealth:
		queue_redraw()
	lastHealth = health
	max_health = get_parent().max_health

func _draw() -> void:
	if health != max_health:
		RectLine.draw(self, Vector2(-size / 2.0, size / 2.0), Vector2((size * (health / max_health)) - (size / 2), size / 2.0), Color("99e550"), 2.0)
		RectLine.draw(self, Vector2(size / 2.0, size / 2.0), Vector2((size / 2.0) - (size * (1.0 - (health / max_health))), size / 2.0), Color("ac3232"), 2.0)
