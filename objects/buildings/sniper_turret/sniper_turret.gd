extends Building

var target := Vector2(1, 0)

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 100

var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	reach = 200
	if team == Enums.Team.RED:
		$Base.material = red_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < max_health / 2.0:
		smoke.emitting = true
	else:
		smoke.emitting = false
	
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	if !enemies:
		return
	var targets = enemies.map(func(x): return x.global_position)
	
	target = Vector2(10000, 0)
	var dist
	var min_dist = 10000.0
	for i in targets:
		dist = global_position.distance_squared_to(i)
		if dist < min_dist:
			min_dist = dist
			target = i
	
	head.rotation = global_position.angle_to_point(target) + (PI/2)
	
	if global_position.distance_to(target) < reach && cooldown.is_stopped():
		head.play()
		var rock = rock_scene.instantiate()
		get_parent().add_child(rock)
		rock.global_position = global_position
		rock.velocity = (target - global_position).normalized() * 250
		rock.damage = damage
		rock.team = team
		cooldown.start()
