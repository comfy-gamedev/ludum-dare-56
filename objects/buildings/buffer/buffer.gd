extends Building

@export var radius = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if radius < reach:
		radius += delta * 100
		queue_redraw()

func _on_timer_timeout() -> void:
	radius = 0.001
	var allies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team == team && global_position.distance_to(x.global_position) < reach)
	if allies:
		for i in allies:
			i.movement_speed *= 2
			i.attack_points *= 1.25
			i.health *= 1.25
			i.max_health *= 1.25
	

func _draw() -> void:
	draw_circle(Vector2(0, 0), radius, Color(0, 1, 0, (reach/radius) - 1.0), false, 2.0)
