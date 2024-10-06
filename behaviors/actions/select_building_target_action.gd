extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var buildings := get_tree().get_nodes_in_group("Building")
	var enemy_buildings = buildings.filter(func(x): return x.team != actor.team)
	
	if enemy_buildings.size() > 0:
		var target
		var dist
		var min_dist = 1000000.0
		for i in enemy_buildings:
			dist = actor.global_position.distance_squared_to(i.global_position)
			if dist < min_dist:
				min_dist = dist
				target = i
		blackboard.set_value("target_building", target)
		
	return SUCCESS
	#else:
		#return FAILURE
