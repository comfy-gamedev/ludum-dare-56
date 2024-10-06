extends Building

var target := Vector2(0, 0)

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 20

var firing_frames = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
		return
	
	target = Vector2(10000, 0)
	var target_node = null
	var dist
	var min_dist = 100000000.0
	for i in enemies:
		dist = global_position.distance_squared_to(i.global_position)
		if dist < min_dist:
			min_dist = dist
			target = i.global_position
			target_node = i
	
	head.rotation = global_position.angle_to_point(target) + (PI/2)
	
	if global_position.distance_to(target) < reach && cooldown.is_stopped():
		head.play()
		target_node.hit(damage * delta)
		firing_frames = 1
		queue_redraw()
	elif firing_frames >= 0:
		firing_frames -= 1
		queue_redraw()

func _draw() -> void:
	if firing_frames > 0:
		draw_line(Vector2(0, 0), to_local(target), Color.CHARTREUSE, 2.0)
