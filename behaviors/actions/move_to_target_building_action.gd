extends ActionLeaf

@export var move_speed = 75
@export var acceptance_radius = 25

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_building = blackboard.get_value("target_building")
	if not is_instance_valid(target_building):
		return FAILURE
		
	var target_pos = target_building.global_position
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
		actor.velocity = move_speed * direction

	# If the distance to the target is less than the step, set the final position.
	if current_distance_to_target <= acceptance_radius:
		return SUCCESS
	else:
		# Otherwise, move towards the target
		actor.move_and_slide()
		return RUNNING
