extends Node2D

@export var size = 16

var lastHealth
var health : float
var max_health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health = get_parent().health
	if health != lastHealth:
		queue_redraw()
	lastHealth = health
	max_health = get_parent().max_health

func _draw() -> void:
	if health != max_health:
		print("HEALTH: " + str(health))
		print("MAXHEALTH: " + str(max_health))
		draw_line(Vector2(-size / 2.0, size / 2.0), Vector2((size * (health / max_health)) - (size / 2), size / 2.0), Color.LIME)
		draw_line(Vector2(size / 2.0, size / 2.0), Vector2((size / 2.0) - (size * (1.0 - (health / max_health))), size / 2.0), Color.RED)
