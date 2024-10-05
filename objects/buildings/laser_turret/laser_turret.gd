extends Building

var target := Vector2(0, 0)

@onready var head := $Head
@onready var cooldown := $Timer
var firing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	reach = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit").filter(func(x): return x.team != team)
	var targets = enemies.map(func(x): return x.global_position)
	
	var dist
	var min_dist = 10000.0
	for i in targets:
		dist = global_position.distance_squared_to(i)
		if dist < min_dist:
			min_dist = dist
			target = i
	
	head.look_at(target)
	if min_dist < reach && cooldown.is_stopped():
		head.play()
		firing = true
		queue_redraw()
	elif firing:
		firing = false
		queue_redraw()

func _draw() -> void:
	draw_line(global_position, target, Color.CHARTREUSE)
