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
@export var reach := 0

var bp_size: Vector2i = Vector2i(1, 1) # set by blueprint

@onready var health := max_health

func _ready() -> void:
	_update_team_material()
	process_mode = PROCESS_MODE_DISABLED
	var light = NIGHT_LIGHT.instantiate()
	light.radius = Vector2(bp_size).length() * 16
	light.sub_viewport = $"../LightsSubViewport" # TODO: BAD VERY BAD OMG
	light.position = (Vector2(-1, -1) + Vector2(bp_size)) * GridManager.CELL_SIZE / 2.0
	add_child(light)
	if team == Enums.Team.BLUE:
		collision_layer = 0b0010
		collision_mask = 0b10000
	elif team == Enums.Team.RED:
		collision_layer = 0b0100
		collision_mask = 0b01000

func hit(damage_taken: float):
	health -= damage_taken
	if health <= 0:
		queue_free()

func on_night() -> void:
	process_mode = PROCESS_MODE_DISABLED

func on_day() -> void:
	process_mode = PROCESS_MODE_INHERIT

func set_team(v: Enums.Team) -> void:
	if team == v:
		return
	team = v
	if is_inside_tree():
		_update_team_material()

func _update_team_material():
	var sprites = (
		find_children("*", "Sprite2D", true, true) +
		find_children("*", "AnimatedSprite2D", true, true))
	
	for sprite: CanvasItem in sprites:
		if sprite.material in TEAM_MATERIALS:
			sprite.material = TEAM_MATERIALS[team]
