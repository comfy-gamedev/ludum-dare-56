extends Building

var target_arrays: Array = []

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 2

var laser_visible = false
@onready var visibility_timer := $VisibilityTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_arrays = []
	
	var target_node = get_farthest_enemy_unit()
	
	head.rotation = global_position.angle_to_point(target_node.global_position) + (PI/2) if target_node else 0.0
	
	if target_node and cooldown.is_stopped():
		var qp = PhysicsShapeQueryParameters2D.new()
		qp.shape = RectangleShape2D.new()
		qp.shape.size = Vector2(reach, 8.0)
		qp.collision_mask = 0b11000
		qp.collide_with_bodies = true
		qp.collide_with_areas = false
		
		var angle = global_position.angle_to_point(target_node.global_position)
		
		for i in 5:
			var theta = i * TAU/5.0
			
			qp.transform.origin = global_position + Vector2(qp.shape.size.x / 2.0, 0.0).rotated(angle + theta)
			qp.transform = qp.transform.rotated_local(angle + theta)
			
			var qr = get_world_2d().direct_space_state.intersect_shape(qp).filter(func (r): return r.collider.team != team)
			
			qr.sort_custom(func (a, b): return global_position.distance_to(a.collider.global_position) < global_position.distance_to(b.collider.global_position))
			
			var targets: Array[Vector2] = []
			
			for qrr in qr:
				var chain_target_node = qrr.collider
				chain_target_node.hit(damage)
				targets.append(to_local(chain_target_node.global_position))
			
			target_arrays.append(targets)
		
		#var qp = PhysicsShapeQueryParameters2D.new()
		#qp.shape = CircleShape2D.new()
		#qp.shape.radius = reach / 2.0
		#qp.collision_mask = 0b11000
		#qp.collide_with_bodies = true
		#qp.collide_with_areas = false
		
		#var current_damage = damage
		
		#print("")
		#print("TESLAAAAA")
		#
		#while target_node:
			#target_node.hit(current_damage)
			#print("    Hit %s for %s" % [target_node, current_damage])
			#
			#current_damage *= 0.8
			#
			#if current_damage < 1.0:
				#break
			#
			#targets.append(to_local(target_node.global_position))
			#qp.exclude += [target_node.get_rid()]
			#
			#qp.transform.origin = target_node.global_position
			#
			#var qr = get_world_2d().direct_space_state.intersect_shape(qp).filter(func (r): return r.collider.team != team)
			#qr.sort_custom(func (a, b): return a.collider.global_position.distance_to(global_position) < b.collider.global_position.distance_to(global_position))
			#
			#target_node = qr[0].collider if qr else null
		
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
			RectLine.draw(self, a, b, color, 2.0)
			a = b

func _draw() -> void:
	if laser_visible:
		for targets in target_arrays:
			_draw_bzzt(targets, Enums.COLOR_PINK1I)
			_draw_bzzt(targets, Enums.COLOR_SKYBLUE2I)
			_draw_bzzt(targets, Enums.COLOR_SKYBLUE3I)

func on_night() -> void:
	super()
	laser_visible = false
	queue_redraw()

func _on_visibility_timer_timeout() -> void:
	laser_visible = false
	queue_redraw()
