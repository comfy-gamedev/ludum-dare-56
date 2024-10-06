extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_building = blackboard.get_value("target_building")
	actor.besiege()
	target_building.hit(actor.attack_points)
	return SUCCESS
