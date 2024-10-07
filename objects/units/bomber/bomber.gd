extends Unit

var bomb_explosion_scene = preload("res://objects/units/bomber/bomb_explosion.tscn")
@onready var click_collision_shape_2d: CollisionShape2D = $ClickCollisionShape2D

func besiege():
	for n in 3:
		var bomb_explosion: Node2D = bomb_explosion_scene.instantiate()
		get_tree().get_root().add_child(bomb_explosion)
		bomb_explosion.position = self.global_position
		#if n == 0:
			#bomb_explosion.get_node("SFX").play()
			
	self.queue_free()


func _on_click_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("build_blueprint"): # and event is InputEventMouseButton:
		besiege()
