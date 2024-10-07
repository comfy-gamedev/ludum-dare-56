extends Building

@export var radius = 100
@onready var sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if radius < reach:
		radius += delta * 100
		queue_redraw()

func _on_timer_timeout() -> void:
	sprite.play()
	radius = 0.001
	for i in detected_friendly_units:
		i.movement_speed += i.base_speed
		i.attack_points += i.base_attack / 8.0
		i.health += i.base_health / 4.0
		i.max_health += i.base_max_health / 4.0
	

func _draw() -> void:
	draw_circle(Vector2(0, 0), radius, Color(0, 1, 0, (reach/radius) - 1.0), false, 2.0)
