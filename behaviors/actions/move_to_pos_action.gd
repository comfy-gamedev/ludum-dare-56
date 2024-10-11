class_name MoveToPosAction
extends ActionLeaf

@export var acceptance_radius = 5

# This action moves the actor towards a given target pos (new_pos in Blackboard).
# Note: This action should always be the child of a TimeLimiterDecorator in the event 
# that the actor is unable to meet the acceptance_radius.
func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_pos = blackboard.get_value("new_pos")
	var distance_to_target = blackboard.get_value("distance_to_target")
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
		actor.move_and_slide()
		return RUNNING
