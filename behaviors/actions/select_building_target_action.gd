extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var buildings := get_tree().get_nodes_in_group("Building")
	var enemy_buildings = buildings.filter(func(x): return x.team == "enemy")
	
	if enemy_buildings.size() > 0:
		blackboard.set_value("target_building", enemy_buildings.pick_random())
		return SUCCESS
	else:
		return FAILURE
