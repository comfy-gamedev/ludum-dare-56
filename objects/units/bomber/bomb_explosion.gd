extends CPUParticles2D

@onready var bomb_explosion_radius_area = $bomb_explosion_radius_area

var damage = 25
#var team = ...

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bomb_explosion_radius_area.collision_layer = 0
	bomb_explosion_radius_area.collision_mask = 0b11111
	await get_tree().physics_frame
	
	var bodies: Array[Node2D] = bomb_explosion_radius_area.get_overlapping_bodies()
	for n in bodies.size():
		if (bodies[n].is_in_group("Unit") or bodies[n].is_in_group("Building")): # and team != body.team:
			print("DMG!!!")
			bodies[n].hit(damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
