extends ActionLeaf

@export var move_speed = 75
@export var acceptance_radius = 5
@export var attack_target = true

# This action moves the actor towards a given target pos (new_pos in Blackboard).
# Note: This action should always be the child of a TimeLimiterDecorator in the event 
# that the actor is unable to meet the acceptance_radius.
# Note2: This should be fish specific movement.
func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_pos = blackboard.get_value("new_pos")
	var distance_to_target = blackboard.get_value("distance_to_target")
	var delta = get_physics_process_delta_time()
	
	# Calculate the direction to the target position
	var direction = (target_pos - actor.position).normalized()
	var current_distance_to_target = actor.position.distance_to(target_pos)
	
	var adjustment_factor = 1
	
	if attack_target:
		actor.velocity = (move_speed * direction) * current_distance_to_target/10
	else:
		if current_distance_to_target > distance_to_target/2:
			adjustment_factor = (current_distance_to_target / distance_to_target) ** 3
			actor.velocity = (move_speed * direction) * adjustment_factor
		else:
			adjustment_factor = (1 - (current_distance_to_target / distance_to_target)) ** 3
			actor.velocity = (move_speed * direction) * adjustment_factor

	# If the distance to the target is less than the step, set the final position.
	if current_distance_to_target <= acceptance_radius:
		return SUCCESS
	else:
		# Otherwise, move towards the target
		actor.move_and_slide()
		return RUNNING
