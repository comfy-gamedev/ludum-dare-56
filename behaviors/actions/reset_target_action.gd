class_name ResetTargetAction
extends ActionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	blackboard.erase_value("target")
	blackboard.erase_value("target_locked")
	return SUCCESS
