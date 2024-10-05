extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var opponents = blackboard.get_value("nearby_opponents")
	
	if opponents != null and opponents.size() > 0:
		print("heeeeeyyyy")
		var target_opponent = opponents.pick_random()
		blackboard.set_value("target_opponent", target_opponent)
		return SUCCESS
	else:
		return FAILURE
