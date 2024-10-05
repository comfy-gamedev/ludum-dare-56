extends Building

@export var radius = 100
@export var heal_strength = 5

var target: Node2D = null
@onready var head := $Head
@onready var visibility_timer = $VisibilityTimer
var laser_visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	reach = 100
	if team == Enums.Team.RED:
		$Base.material = red_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < max_health / 2.0:
		smoke.emitting = true
	else:
		smoke.emitting = false


func _on_timer_timeout() -> void:
	var buildings := get_tree().get_nodes_in_group("Building").filter(func(x): return x.team == team && x != self && x.health != x.max_health)
	if !buildings:
		return
	
	#var target_dist = 10000
	var dist
	var min_dist = 10000.0
	for i in buildings:
		dist = global_position.distance_squared_to(i.global_position)
		if dist < min_dist:
			min_dist = dist
			target = i
	
	head.rotation = global_position.angle_to_point(target.global_position) + (PI/2)
	
	if global_position.distance_to(target.global_position) < reach:
		head.play()
		laser_visible = true
		queue_redraw()
		visibility_timer.start()
		target.health += heal_strength
		target.health = min(target.health, target.max_health)


func _on_visibility_timer_timeout() -> void:
	laser_visible = false
	queue_redraw()

func _draw() -> void:
	if laser_visible:
		draw_line(Vector2(0, 0), to_local(target.global_position), Color.MEDIUM_SEA_GREEN, 1.5)
