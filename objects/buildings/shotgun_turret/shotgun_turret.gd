extends Building

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 6
@export var pellets = 5

var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_unit = get_closest_enemy_unit()
	
	if not target_unit:
		return
	
	head.rotation = global_position.angle_to_point(target_unit.global_position) + (PI/2)
	
	if cooldown.is_stopped():
		head.play()
		var angle_offset = -PI/4
		for i in pellets:
			var rock = rock_scene.instantiate()
			get_parent().add_child(rock)
			rock.global_position = global_position
			rock.velocity = (target_unit.global_position - global_position).normalized().rotated(angle_offset) * 100
			angle_offset += PI/12
			rock.damage = damage
			rock.team = team
		cooldown.start()
