extends ActionLeaf

@export var radius: float = 75

func tick(actor: Node, blackboard: Blackboard) -> int:
	var new_pos = get_random_pos_within_radius(actor.position.x, actor.position.y, radius)
	blackboard.set_value("new_pos", new_pos)
	var distance_to_target = actor.position.distance_to(new_pos)
	blackboard.set_value("distance_to_target", distance_to_target)
	return SUCCESS

func get_random_pos_within_radius(pos_x: float, pos_y: float, radius: float) -> Vector2:
	# Random angle in radians
	var angle = randf() * PI * 2
	# Random distance from the center within the radius
	var distance = randf_range(0.5, 1) * radius
	# Calculate the new x and y positions
	var random_x = pos_x + cos(angle) * distance
	var random_y = pos_y + sin(angle) * distance
	return Vector2(random_x, random_y)
