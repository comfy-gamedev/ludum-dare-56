extends Building

var targets: Array[Vector2] = []

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 2

var laser_visible = false
@onready var visibility_timer := $VisibilityTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
		return
	
	targets = [Vector2(10000, 0)]
	var target_node = null
	var dist
	var min_dist = 10000.0
	for i in enemies:
		dist = global_position.distance_squared_to(i.global_position)
		if dist < min_dist:
			min_dist = dist
			target_node = i
	targets[0] = target_node.global_position
	
	head.rotation = global_position.angle_to_point(targets[0]) + (PI/2)
	
	if global_position.distance_to(targets[0]) < reach && cooldown.is_stopped():
		head.play()
		var current = 0
		enemies.erase(target_node)
		while enemies.size() > 0:
			target_node.hit(damage)
			current += 1
			if randf() > .75:
				break
			min_dist = 10000.0
			for i in enemies:
				dist = global_position.distance_squared_to(i.global_position)
				if dist < min_dist:
					min_dist = dist
					target_node = i
			if global_position.distance_to(target_node.global_position) < reach / 2.0:
				targets.append(target_node.global_position)
				enemies.erase(target_node)
			else:
				break
			
		laser_visible = true
		visibility_timer.start()
		queue_redraw()
		cooldown.start()

func _draw() -> void:
	if laser_visible:
		for i in range(targets.size()):
			if i == 0:
				draw_line(Vector2(0, 0), to_local(targets[i]), Color.CYAN, 1.0)
			else:
				draw_line(to_local(targets[i-1]), to_local(targets[i]), Color.CYAN, 1.0)


func _on_visibility_timer_timeout() -> void:
	laser_visible = false
	queue_redraw()
