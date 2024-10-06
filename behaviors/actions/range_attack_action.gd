extends ActionLeaf

var range = 50
var bullet_scene = preload("res://objects/units/mage/magic_bullet.tscn")

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_opponent = blackboard.get_value("target_opponent")
	if not is_instance_valid(target_opponent):
		return FAILURE
		
	if actor.global_position.distance_to(target_opponent.global_position) < range: #&& cooldown.is_stopped():
		var bullet = bullet_scene.instantiate()
		actor.get_parent().add_child(bullet)
		bullet.global_position = actor.global_position
		bullet.velocity = (target_opponent.global_position - actor.global_position).normalized() * 50
		bullet.damage = 25 #actor.attack_points
		bullet.team = actor.team
		print("shoooot")
		#cooldown.start()
	else:
		return SUCCESS
	
	if is_instance_valid(target_opponent):
		return SUCCESS
	else:
		return FAILURE
