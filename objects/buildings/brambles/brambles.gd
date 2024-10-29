extends Area2D

const NIGHT_LIGHT = preload("res://objects/night_light/night_light.tscn")

@export var team: Enums.Team = Enums.Team.BLUE: set = set_team
@export var building_type: Enums.BuildingType = Enums.BuildingType.UNSPECIFIED

@export var max_health := 50
@export var reach := 0: set = set_reach

@export var damage: float = 0.1

var bp_size: Vector2i = Vector2i(1, 1) # set by blueprint

var detection_area: Area2D = self

var detected_enemy_units: Array[Node2D] = []

@onready var health := max_health
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	material = TeamMaterial.get_material(team)
	_update_collision_bits()
	_update_reach()
	
	process_mode = PROCESS_MODE_DISABLED
	var light = NIGHT_LIGHT.instantiate()
	light.radius = Vector2(bp_size).length() * 16
	light.position = (Vector2(bp_size) - Vector2.ONE) * GridManager.CELL_SIZE / 2.0
	add_child(light)
	
	if light.sub_viewport == null:
		light.queue_free()
	
	body_entered.connect(_on_detection_area_body_entered)
	body_exited.connect(_on_detection_area_body_exited)

func _physics_process(delta: float) -> void:
	for e in detected_enemy_units:
		e.slowed = true
		e.hit(damage, false)
		hit(1)

func _update_collision_bits() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = 0
		collision_mask = PhysicsLayers.RED_UNITS
	elif team == Enums.Team.RED:
		collision_layer = 0b00000
		collision_mask =  PhysicsLayers.BLUE_UNITS

func hit(damage_taken: float):
	health -= damage_taken
	if health <= 0:
		queue_free()

func is_targetable() -> bool:
	return false

func get_target_point(global_from: Vector2) -> Vector2:
	var rec = Rect2(
		Vector2(0, 0),
		Vector2(bp_size - Vector2i.ONE) * GridManager.CELL_SIZE)
	var c = rec.get_center() + global_position
	c += rec.size.length() * (global_from - c).normalized()
	return c

func set_reach(v: float) -> void:
	reach = v

func on_night() -> void:
	process_mode = PROCESS_MODE_DISABLED
	detected_enemy_units = []

func on_day() -> void:
	process_mode = PROCESS_MODE_INHERIT

func set_team(v: Enums.Team) -> void:
	if team == v:
		return
	team = v
	material = TeamMaterial.get_material(team)
	_update_collision_bits()

func _update_reach() -> void:
	collision_shape_2d.shape.radius = reach

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Unit"):
		if body.team != team:
			detected_enemy_units.append(body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Unit"):
		if body.team != team:
			detected_enemy_units.erase(body)
