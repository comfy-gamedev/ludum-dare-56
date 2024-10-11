extends CPUParticles2D

@onready var bomb_explosion_radius_area = $bomb_explosion_radius_area

var damage = 25

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout
	
	MusicMan.sfx(preload("res://assests/SFX/bomber-explode.wav"), "bomber")
	
	var bodies: Array[Node2D] = bomb_explosion_radius_area.get_overlapping_bodies()
	for n in bodies.size():
		if (bodies[n].is_in_group("Unit") or bodies[n].is_in_group("Building")): # and team != body.team:
			bodies[n].hit(damage)


func _on_finished() -> void:
	queue_free()
