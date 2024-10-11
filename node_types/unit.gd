extends PhysicsBody2D
class_name Unit

@export var team = Enums.Team.BLUE: set = set_team
@export var unit_type = "melee" # | "siege" | "ranged"
@export var max_health := 50.0
@export var attack_points = 10
@export var movement_speed = 75.0: get = get_movement_speed

@export var detection_radius: float = 35.0
@export var attack_acceptance_range: float = 12.0
@export var recoil_distance: float = 40.0

@export var push_radius: float = 5.0

var push_area: Area2D
var detection_area: Area2D

var slowed: bool = false

var sound_cooldown := 0.0

@onready var health := max_health

@onready var base_speed = movement_speed
@onready var base_attack = attack_points
@onready var base_health = health
@onready var base_max_health = max_health

func get_movement_speed() -> float:
	return movement_speed * 0.05 if slowed else movement_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if push_radius > 0.0:
		push_area = Area2D.new()
		push_area.name = "PushArea2D"
		var pa_shape = CollisionShape2D.new()
		pa_shape.shape = CircleShape2D.new()
		pa_shape.shape.radius = push_radius
		push_area.add_child(pa_shape)
		push_area.collision_layer = 0
		push_area.collision_mask = PhysicsLayers.ANY_UNITS
		push_area.input_pickable = false
		add_child(push_area, false, Node.INTERNAL_MODE_BACK)
	
	if detection_radius > 0.0:
		detection_area = Area2D.new()
		detection_area.name = "MeleeArea2D"
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = CircleShape2D.new()
		collision_shape.shape.radius = detection_radius
		detection_area.add_child(collision_shape)
		detection_area.collision_layer = 0
		detection_area.collision_mask = PhysicsLayers.ANY_TARGET
		detection_area.input_pickable = false
		add_child(detection_area, false, Node.INTERNAL_MODE_BACK)
	
	_update_team_material()
	_update_collision_bits()
	

func _physics_process(delta: float) -> void:
	sound_cooldown -= delta
	for b in push_area.get_overlapping_bodies():
		var v = global_position - b.global_position
		if not v.is_zero_approx():
			global_position += v.normalized() * (2.0 / v.length())
	if slowed:
		(func ():
			slowed = false
		).call_deferred()

func _update_collision_bits() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = PhysicsLayers.BLUE_UNITS
		collision_mask =  PhysicsLayers.RED_BUILDINGS
	elif team == Enums.Team.RED:
		collision_layer = PhysicsLayers.RED_UNITS
		collision_mask =  PhysicsLayers.BLUE_BUILDINGS

func hit(damage_taken: float, play_sfx: bool = true):
	if play_sfx:
		if sound_cooldown <= 0.0:
			MusicMan.sfx(preload("res://assests/SFX/hit.wav"), "hit", 1)
			sound_cooldown = 0.1
	health -= damage_taken
	if health <= 0:
		queue_free()

func set_team(v: Enums.Team) -> void:
	if team == v:
		return
	team = v
	if is_inside_tree():
		_update_team_material()
	_update_collision_bits()

func get_closest_detected_enemy_unit() -> Node2D:
	if not is_instance_valid(detection_area):
		return null
	
	var overlaps = detection_area.get_overlapping_bodies() \
		.filter(func (x): return x.team != team and x is Unit)
	
	if overlaps.is_empty():
		return null
	
	overlaps.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	
	return overlaps[0]

func get_closest_detected_enemy_building() -> Node2D:
	if not is_instance_valid(detection_area):
		return null
	
	var overlaps = detection_area.get_overlapping_bodies() \
		.filter(func (x): return x.team != team and x is Building)
	
	if overlaps.is_empty():
		return null
	
	overlaps.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	
	return overlaps[0]

func _update_team_material():
	var sprite = get_node_or_null(^"AnimatedSprite2D")
	if sprite:
		match team:
			Enums.Team.BLUE:
				sprite.material = preload("res://materials/team_blue.tres")
			Enums.Team.RED:
				sprite.material = preload("res://materials/team_red.tres")
