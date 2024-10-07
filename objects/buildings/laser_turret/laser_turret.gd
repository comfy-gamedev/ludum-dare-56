extends Building

var target_node

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 20

var laser_visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
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
		queue_redraw()
	else:
		laser_visible = false
		queue_redraw()

func _draw() -> void:
	if target_node and laser_visible:
		draw_line(Vector2(0, 0), to_local(target_node.global_position), Color.CHARTREUSE, 2.0)
