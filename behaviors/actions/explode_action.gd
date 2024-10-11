class_name ExplodeAction
extends ActionLeaf

const BOMB_EXPLOSION = preload("res://objects/units/bomber/bomb_explosion.tscn")

func tick(actor: Node, blackboard: Blackboard) -> int:
	var bomb_explosion = BOMB_EXPLOSION.instantiate()
	bomb_explosion.position = actor.position
	actor.get_parent().add_child(bomb_explosion)
	
	actor.queue_free()
	
	return SUCCESS
