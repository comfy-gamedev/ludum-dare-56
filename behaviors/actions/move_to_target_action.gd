class_name MoveToTargetAction
extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if not is_instance_valid(target):
		return FAILURE
	
	var target_pos = target.get_target_point(actor.global_position) if target is Building else target.global_position
	
	var distance_to_target = actor.position.distance_to(target_pos)
	
	if distance_to_target <= actor.attack_acceptance_range:
		return SUCCESS
	
	var direction: Vector2 = (target_pos - actor.position).normalized()
	
	# Flip sprite if it exists.
	var spriteNode = actor.get_node_or_null("AnimatedSprite2D")
	if spriteNode:
		spriteNode.flip_h = direction.x > 0
	
	# Otherwise, move towards the target
	actor.velocity = actor.movement_speed * direction
	
	if actor.move_and_slide():
		var collider = actor.get_last_slide_collision().get_collider()
		if collider is Unit or collider is Building:
			blackboard.set_value("target", collider)
			blackboard.set_value("target_locked", true)
	
	distance_to_target = actor.position.distance_to(target_pos)
	
	# If the distance to the target is less than the step, set the final position.
	if distance_to_target <= actor.attack_acceptance_range:
		return SUCCESS
	else:
		return RUNNING
