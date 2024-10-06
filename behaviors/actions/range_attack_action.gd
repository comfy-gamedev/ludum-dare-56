extends ActionLeaf

var range = 75
var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target_opponent = blackboard.get_value("target_opponent")
	if not is_instance_valid(target_opponent):
		return FAILURE
		
	if actor.global_position.distance_to(target_opponent.global_position) < range: #&& cooldown.is_stopped():
		var rock = rock_scene.instantiate()
		print(rock)
		actor.get_parent().add_child(rock)
		rock.global_position = actor.global_position
		rock.velocity = (target_opponent.global_position - actor.global_position).normalized() * 50
		rock.damage = 25 #actor.attack_points
		rock.team = actor.team
		print("shoooot")
		#cooldown.start()
	else:
		return SUCCESS
	
	if is_instance_valid(target_opponent):
		return SUCCESS
	else:
		return FAILURE
