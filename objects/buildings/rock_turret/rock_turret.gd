extends Building

var target := Vector2(1, 0)

@onready var head := $Head
@onready var cooldown := $Timer
var rock_scene = preload("res://objects/buildings/rock_turret/rock.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	reach = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): x.team != team)
	var targets = enemies.map(func(x): return x.global_position)
	
	var dist
	var min_dist
	for i in targets:
		dist = global_position.distance_squared_to(i)
		if dist < min_dist:
			min_dist = dist
			target = i
	
	head.look_at(target)
	if min_dist < reach && cooldown.is_stopped():
		head.play()
		var rock = rock_scene.instantiate()
		rock.velocity = (target - global_position).normalized() * 5
		cooldown.start()
