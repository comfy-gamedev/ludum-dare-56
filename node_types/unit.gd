extends PhysicsBody2D
class_name Unit

@export var team = Enums.Team.BLUE: set = set_team
@export var unit_type = "melee" # | "siege" | "ranged"
@export var max_health := 50.0
@export var attack_points = 10
@export var movement_speed = 75.0: get = get_movement_speed

@onready var health := max_health

@onready var base_speed = movement_speed
@onready var base_attack = attack_points
@onready var base_health = health
@onready var base_max_health = max_health

var push_area: Area2D

var slowed: bool = false

var sound_cooldown := 0.0

@export var push_shape = preload("res://assests/push_shape.tres")

func get_movement_speed() -> float:
	return movement_speed * 0.5 if slowed else movement_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_team_material()
	_update_collision_bits()
	
	push_area = Area2D.new()
	var pa_shape = CollisionShape2D.new()
	pa_shape.shape = push_shape
	push_area.add_child(pa_shape)
	push_area.collision_layer = 0
	push_area.collision_mask = 0b11000
	push_area.input_pickable = false
	
	add_child(push_area, false, Node.INTERNAL_MODE_BACK)

func _physics_process(delta: float) -> void:
	sound_cooldown -= delta
	for b in push_area.get_overlapping_bodies():
		var v = global_position - b.global_position
		if not v.is_zero_approx():
			global_position += v.normalized() * (2.0 / v.length())
	(func ():
		slowed = false
	).call_deferred()

func _update_collision_bits() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = 0b01000
		collision_mask =  0b00100
	elif team == Enums.Team.RED:
		collision_layer = 0b10000
		collision_mask =  0b00010

func hit(damage_taken: float):
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

var esr_v = null

func disable_unit_targeting() -> void:
	var bb = get_node_or_null("Blackboard")
	var esr = get_node_or_null("EnemySeekingRadius")
	
	if bb:
		bb.set_value("nearby_opponents", [])
	
	if esr:
		esr_v = esr.collision_mask
		esr.collision_mask = 0

func enable_unit_targeting() -> void:
	if esr_v == null:
		return
	
	var esr = get_node_or_null("EnemySeekingRadius")
	
	if esr:
		esr.collision_mask = esr_v

func _update_team_material():
	var sprite = get_node_or_null(^"AnimatedSprite2D")
	if sprite:
		match team:
			Enums.Team.BLUE:
				sprite.material = preload("res://materials/team_blue.tres")
			Enums.Team.RED:
				sprite.material = preload("res://materials/team_red.tres")
