extends CPUParticles2D

@onready var bomb_explosion_radius_area = $bomb_explosion_radius_area

var damage = 25

func _ready() -> void:
	bomb_explosion_radius_area.collision_layer = 1
	bomb_explosion_radius_area.collision_mask = 0b11111
	
	await get_tree().create_timer(0.05).timeout
	
	var bodies: Array[Node2D] = bomb_explosion_radius_area.get_overlapping_bodies()
	for n in bodies.size():
		if (bodies[n].is_in_group("Unit") or bodies[n].is_in_group("Building")): # and team != body.team:
			bodies[n].hit(damage)


func _on_finished() -> void:
	queue_free()
