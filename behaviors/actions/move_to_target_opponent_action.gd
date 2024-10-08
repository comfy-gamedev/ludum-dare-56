extends ActionLeaf

@export var acceptance_radius = 25

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_opponent = blackboard.get_value("target_opponent")
	if not is_instance_valid(target_opponent):
		return FAILURE
		
	var target_pos = target_opponent.global_position
	var distance_to_target = actor.position.distance_to(target_pos)
	var delta = get_physics_process_delta_time()
	
	# Calculate the direction to the target position
	var direction: Vector2 = (target_pos - actor.position).normalized()
	var current_distance_to_target = actor.position.distance_to(target_pos)
	
	# Flip sprite if it exists.
	var spriteNode = actor.get_node_or_null("AnimatedSprite2D")
	if spriteNode:
		if direction.x > 0:
			spriteNode.flip_h = true
		else:
			spriteNode.flip_h = false
	
	if current_distance_to_target > distance_to_target/2:
		actor.velocity = actor.movement_speed * direction

	# If the distance to the target is less than the step, set the final position.
	if current_distance_to_target <= acceptance_radius:
		return SUCCESS
	else:
		# Otherwise, move towards the target
		if actor.move_and_slide():
			actor.disable_unit_targeting()
			return FAILURE
		
		return RUNNING
