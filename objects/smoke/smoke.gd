extends CPUParticles2D

func _process(delta: float) -> void:
	emitting = get_parent().health < get_parent().max_health / 2.0
