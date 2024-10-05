extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_building = blackboard.get_value("target_building")
	target_building.hit(actor.attack_points)
	
	if is_instance_valid(target_building):
		return SUCCESS
	else:
		return FAILURE
