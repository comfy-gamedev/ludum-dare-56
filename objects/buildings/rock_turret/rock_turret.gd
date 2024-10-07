extends Building

var target := Vector2(1, 0)

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 10

var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_unit = get_closest_enemy_unit()
	
	if not target_unit:
		return
	
	target = target_unit.global_position
	
	head.rotation = global_position.angle_to_point(target) + (PI/2)
	
	if cooldown.is_stopped():
		head.play()
		var rock = rock_scene.instantiate()
		rock.global_position = global_position
		rock.velocity = (target - global_position).normalized() * 50
		rock.damage = damage
		rock.team = team
		get_parent().add_child(rock)
		cooldown.start()
