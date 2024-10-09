extends Building

@export var radius = 100
@export var heal_strength = 5

var target_building: Node2D = null
@onready var head := $Head
@onready var visibility_timer = $VisibilityTimer
var laser_visible = false

func _on_timer_timeout() -> void:
	var healable_buildings = detected_friendly_buildings.filter(func(x): return x != self and x.health < x.max_health)
	healable_buildings.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	
	target_building = healable_buildings[0] if healable_buildings else null
	
	if not target_building:
		return
	
	head.rotation = global_position.angle_to_point(target_building.global_position) + (PI/2)
	head.play()
	laser_visible = true
	visibility_timer.start()
	target_building.health += heal_strength
	target_building.health = min(target_building.health, target_building.max_health)
	queue_redraw()


func _on_visibility_timer_timeout() -> void:
	laser_visible = false
	queue_redraw()

func _draw() -> void:
	if laser_visible:
		RectLine.draw(self, Vector2(0, 0), to_local(target_building.global_position), Color.MEDIUM_SEA_GREEN, 1.5)
