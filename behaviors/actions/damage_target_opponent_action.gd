extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_opponent = blackboard.get_value("target_opponent")
	target_opponent.hit(actor.attack_points)
	
	if is_instance_valid(target_opponent):
		return SUCCESS
	else:
		return FAILURE
