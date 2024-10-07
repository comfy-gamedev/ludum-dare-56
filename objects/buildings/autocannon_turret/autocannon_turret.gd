extends Building

var target := Vector2(1, 0)

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 3

var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
		return
	var targets = enemies.map(func(x): return x.global_position)
	
	target = Vector2(10000, 0)
	var dist
	var min_dist = 100000000.0
	for i in targets:
		dist = global_position.distance_squared_to(i)
		if dist < min_dist:
			min_dist = dist
			target = i
	
	head.rotation = global_position.angle_to_point(target) + (PI/2)
	
	if global_position.distance_to(target) < reach && cooldown.is_stopped():
		head.play()
		var rock = rock_scene.instantiate()
		rock.global_position = global_position
		rock.velocity = (target - global_position).normalized().rotated(randf_range(-PI/6, PI/6)) * 150
		rock.damage = damage
		rock.team = team
		get_parent().add_child(rock)
		cooldown.start()
