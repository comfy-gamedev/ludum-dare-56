extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != actor.team)
	
	if enemies.size() > 0:
		var target
		var dist
		var min_dist = 1000000.0
		for i in enemies:
			dist = actor.global_position.distance_squared_to(i.global_position)
			if dist < min_dist:
				min_dist = dist
				target = i
		blackboard.set_value("target_opponent", target)
		return SUCCESS
	else:
		return FAILURE
