extends ActionLeaf

#@export var move_speed = 25
@export var acceptance_radius = 50

# This action causes the actor to move away from a target pos (new_pos in blackboard).
func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_opponent = blackboard.get_value("target_opponent")
	if not is_instance_valid(target_opponent):
		return FAILURE
		
	var target_pos = target_opponent.global_position
	var delta = get_physics_process_delta_time()
	
	# Calculate the direction away from the target position
	var direction = (target_pos - actor.position).normalized() * -1
	var distance_to_target = actor.position.distance_to(target_pos)
	actor.velocity = actor.movement_speed/3 * direction

	# Move away from the target
	if distance_to_target < acceptance_radius:
		actor.move_and_slide()
		return RUNNING
	else:
		return SUCCESS
