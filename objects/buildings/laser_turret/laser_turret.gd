extends Building

var target_node

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 20

var laser_visible = false

var rd_t: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rd_t += delta
	
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
		laser_visible = false
		queue_redraw()
		return
	
	target_node = null
	var dist
	var min_dist = 100000000.0
	for i in enemies:
		dist = global_position.distance_squared_to(i.global_position)
		if dist < min_dist:
			min_dist = dist
			target_node = i
	
	head.rotation = global_position.angle_to_point(target_node.global_position) + (PI/2)
	
	if global_position.distance_to(target_node.global_position) < reach && cooldown.is_stopped():
		head.play()
		target_node.hit(damage * delta)
		laser_visible = true
		_maybe_queue_redraw()
	else:
		laser_visible = false
		queue_redraw()

func _maybe_queue_redraw() -> void:
	if rd_t >= 0.1:
		rd_t -= 0.1
		if rd_t >= 0.1:
			rd_t = 0.0
		queue_redraw()

func _draw_bzzt(to: Vector2, color: Color) -> void:
	var n = maxf(1, roundi(to.length() / 8.0))
	var a = Vector2.ZERO
	for i in range(1, n+1):
		var b = to * float(i) / float(n)
		b += Vector2.from_angle(randf_range(0.0, TAU)) * 4.0
		draw_line(a, b, color, 2.0)
		a = b

func _draw() -> void:
	if target_node and laser_visible:
		var d = to_local(target_node.global_position)
		_draw_bzzt(d, Color("ac3232"))
		_draw_bzzt(d, Color("d95763"))
		_draw_bzzt(d, Color("d77bba"))
