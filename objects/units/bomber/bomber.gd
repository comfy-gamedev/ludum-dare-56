extends Unit

var bomb_explosion_scene = preload("res://objects/units/bomber/bomb_explosion.tscn")

func besiege():
	var bomb_explosion: Node2D = bomb_explosion_scene.instantiate()
	get_parent().add_child(bomb_explosion)
	bomb_explosion.global_position = self.global_position
	
	self.queue_free()


func _on_click_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("build_blueprint"): # and event is InputEventMouseButton:
		besiege()
