extends Building

var target := Vector2(1, 0)

@onready var head := $Head
@onready var cooldown := $Timer
@export var damage = 10

var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	reach = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
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
		rock.velocity = (target - global_position).normalized() * 50
		rock.damage = damage
		cooldown.start()
