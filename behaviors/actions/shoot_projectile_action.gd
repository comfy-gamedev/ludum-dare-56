class_name ShootProjectileAction
extends ActionLeaf

@export var bullet_scene: PackedScene = preload("res://objects/units/mage/magic_bullet.tscn")
@export var bullet_speed: float = 50.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if not is_instance_valid(target):
		return FAILURE
	
	var target_pos = target.get_target_point(actor.global_position) if target is Building else target.global_position
	
	var direction: Vector2 = actor.global_position.direction_to(target_pos)
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = actor.global_position
	bullet.velocity = direction * bullet_speed
	bullet.damage = actor.attack_points
	bullet.team = actor.team
	actor.get_parent().add_child(bullet)
	
	return SUCCESS
