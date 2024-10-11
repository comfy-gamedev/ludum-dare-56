class_name RecoilFromTargetAction
extends ActionLeaf

var _recoil_distance: float

func before_run(actor: Node, blackboard: Blackboard) -> void:
	_recoil_distance = actor.recoil_distance * randf_range(0.95, 1.05)

# This action causes the actor to move away from a target pos (new_pos in blackboard).
func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if not is_instance_valid(target):
		return FAILURE
	
	var target_pos = target.get_target_point(actor.global_position) if target is Building else target.global_position
	
	# Calculate the direction away from the target position
	var direction = actor.position.direction_to(target_pos)
	
	actor.velocity = -actor.movement_speed/3.0 * direction
	actor.move_and_slide()
	
	var distance_to_target = actor.position.distance_to(target_pos)
	
	# Move away from the target
	if distance_to_target < _recoil_distance:
		return RUNNING
	else:
		return SUCCESS
