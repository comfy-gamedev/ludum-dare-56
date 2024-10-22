class_name Building
extends PhysicsBody2D

const NIGHT_LIGHT = preload("res://objects/night_light/night_light.tscn")

const TEAM_MATERIALS = [
	preload("res://materials/team_blue.tres"),
	preload("res://materials/team_red.tres"),
]


@export var team: Enums.Team = Enums.Team.BLUE: set = set_team
@export var building_type: Enums.BuildingType = Enums.BuildingType.UNSPECIFIED

@export var max_health := 50
@export var reach := 0: set = set_reach

@export var armor: float = 0.0

var bp_size: Vector2i = Vector2i(1, 1) # set by blueprint

var detection_area: Area2D

var detected_friendly_buildings: Array[Node2D] = []
var detected_friendly_units: Array[Node2D] = []
var detected_enemy_buildings: Array[Node2D] = []
var detected_enemy_units: Array[Node2D] = []

@onready var health := max_health

func _ready() -> void:
	_update_team_material()
	_update_collision_bits()
	_update_reach()
	
	process_mode = PROCESS_MODE_DISABLED
	var light = NIGHT_LIGHT.instantiate()
	light.radius = Vector2(bp_size).length() * 16
	light.position = (Vector2(-1, -1) + Vector2(bp_size)) * GridManager.CELL_SIZE / 2.0
	add_child(light)

func _update_collision_bits() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = 0b00010
		collision_mask =  0b10100
	elif team == Enums.Team.RED:
		collision_layer = 0b00100
		collision_mask =  0b01010

func hit(damage_taken: float):
	damage_taken -= armor
	if damage_taken < 1.0:
		damage_taken = 1.0
	health -= damage_taken
	MusicMan.sfx(preload("res://assests/SFX/hit.wav"), "hit", 1)
	if health <= 0:
		MusicMan.sfx(preload("res://assests/SFX/destroy-building.wav"), "destroy")
		queue_free()

func is_targetable() -> bool:
	return true

func get_center_offset() -> Vector2:
	var rec = Rect2(
		Vector2.ZERO,
		Vector2(bp_size - Vector2i.ONE) * GridManager.CELL_SIZE)
	return rec.get_center()

func get_target_point(global_from: Vector2) -> Vector2:
	var size = GridManager.CELL_SIZE * (Vector2(bp_size) - Vector2(0.5, 0.5))
	var c = get_center_offset() + global_position
	c += size.length() * 0.5 * c.direction_to(global_from)
	return c

func set_reach(v: float) -> void:
	reach = v

func on_night() -> void:
	process_mode = PROCESS_MODE_DISABLED
	detected_friendly_buildings = []
	detected_friendly_units = []
	detected_enemy_buildings = []
	detected_enemy_units = []

func on_day() -> void:
	process_mode = PROCESS_MODE_INHERIT
	if detection_area:
		remove_child(detection_area)
		add_child(detection_area)

func set_team(v: Enums.Team) -> void:
	if team == v:
		return
	team = v
	if is_inside_tree():
		_update_team_material()
	_update_collision_bits()

func get_closest_enemy_unit() -> Node2D:
	detected_enemy_units.sort_custom(func (a, b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	return detected_enemy_units[0] if detected_enemy_units else null

func get_farthest_enemy_unit() -> Node2D:
	detected_enemy_units.sort_custom(func (a, b): return a.global_position.distance_to(global_position) > b.global_position.distance_to(global_position))
	return detected_enemy_units[0] if detected_enemy_units else null

func _update_team_material():
	var sprites = (
		find_children("*", "Sprite2D", true, true) +
		find_children("*", "AnimatedSprite2D", true, true))
	
	for sprite: CanvasItem in sprites:
		if sprite.material in TEAM_MATERIALS:
			sprite.material = TEAM_MATERIALS[team]

func _update_reach() -> void:
	if reach == 0.0:
		if is_instance_valid(detection_area):
			detection_area.queue_free()
			detection_area = null
		detected_friendly_buildings = []
		detected_friendly_units = []
		detected_enemy_buildings = []
		detected_enemy_units = []
	else:
		if not is_instance_valid(detection_area):
			detection_area = Area2D.new()
			var shape = CollisionShape2D.new()
			shape.shape = CircleShape2D.new()
			detection_area.add_child(shape)
			detection_area.collision_layer = 1
			detection_area.collision_mask = 0b11110
			detection_area.body_entered.connect(_on_detection_area_body_entered)
			detection_area.body_exited.connect(_on_detection_area_body_exited)
			add_child(detection_area, false, Node.INTERNAL_MODE_BACK)
		detection_area.get_child(0).shape.radius = reach

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Building"):
		if body.team != team:
			detected_enemy_buildings.append(body)
		else:
			detected_friendly_buildings.append(body)
	elif body.is_in_group("Unit"):
		if body.team != team:
			detected_enemy_units.append(body)
		else:
			detected_friendly_units.append(body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Building"):
		if body.team != team:
			detected_enemy_buildings.erase(body)
		else:
			detected_friendly_buildings.erase(body)
	elif body.is_in_group("Unit"):
		if body.team != team:
			detected_enemy_units.erase(body)
		else:
			detected_friendly_units.erase(body)
