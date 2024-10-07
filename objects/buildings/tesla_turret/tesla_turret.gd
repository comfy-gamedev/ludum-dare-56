extends Building

var targets: Array[Vector2] = []

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 2

var laser_visible = false
@onready var visibility_timer := $VisibilityTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	targets = []
	
	var target_node = get_closest_enemy_unit()
	
	head.rotation = global_position.angle_to_point(target_node.global_position) + (PI/2) if target_node else 0.0
	
	if target_node and cooldown.is_stopped():
		var qp = PhysicsShapeQueryParameters2D.new()
		qp.shape = CircleShape2D.new()
		qp.shape.radius = reach / 2.0
		qp.collision_mask = 0b11000
		qp.collide_with_bodies = true
		qp.collide_with_areas = false
		
		while target_node:
			target_node.hit(damage)
			
			targets.append(to_local(target_node.global_position))
			qp.exclude += [target_node.get_rid()]
			
			qp.transform.origin = target_node.global_position
			
			var qr = get_world_2d().direct_space_state.intersect_shape(qp).filter(func (r): return r.collider.team != team)
			qr.sort_custom(func (a, b): return a.collider.global_position.distance_to(global_position) < b.collider.global_position.distance_to(global_position))
			
			target_node = qr[0].collider if qr else null
		
		head.play()
		laser_visible = true
		visibility_timer.start()
		cooldown.start()
		queue_redraw()

func _draw_bzzt(to: Array[Vector2], color: Color) -> void:
	var a = Vector2.ZERO
	for v in to:
		var n = maxf(1, roundi(v.distance_to(a) / 8.0))
		for i in range(1, n+1):
			var b = a + (v - a) * float(i) / float(n)
			b += Vector2.from_angle(randf_range(0.0, TAU)) * 4.0
			draw_line(a, b, color, 2.0)
			a = b

func _draw() -> void:
	if laser_visible:
		_draw_bzzt(targets, Color("76428a"))
		_draw_bzzt(targets, Color("639bff"))
		_draw_bzzt(targets, Color("5fcde4"))

func on_night() -> void:
	super()
	laser_visible = false
	queue_redraw()

func _on_visibility_timer_timeout() -> void:
	laser_visible = false
	queue_redraw()
