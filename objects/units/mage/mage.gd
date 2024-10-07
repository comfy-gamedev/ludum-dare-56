extends Unit

@onready var blackboard: Blackboard = $Blackboard
@onready var enemy_seeking_radius: Area2D = $EnemySeekingRadius

func _physics_process(delta: float) -> void:
	super(delta)
	var bodies = enemy_seeking_radius.get_overlapping_bodies().filter(func (x): return x.is_in_group("Unit"))
	var opposing_units = bodies.filter(func (x): return x.team != team)
	blackboard.set_value("nearby_opponents", opposing_units)
