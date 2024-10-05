extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_building = blackboard.get_value("target_building")
	target_building.hit(10)
	
	if is_instance_valid(target_building):
		return SUCCESS
	else:
		return FAILURE
