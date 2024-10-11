class_name DamageTargetAction
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	target.hit(actor.attack_points)
	
	if is_instance_valid(target):
		return SUCCESS
	else:
		return FAILURE
