class_name Building
extends Node2D

@export var team: Enums.Team = Enums.Team.BLUE: set = set_team
@export var building_type: Enums.BuildingType = Enums.BuildingType.UNSPECIFIED

@export var max_health := 50
@export var reach := 0

var health := max_health

const TEAM_MATERIALS = [
	preload("res://materials/team_blue.tres"),
	preload("res://materials/team_red.tres"),
]

func _ready() -> void:
	_update_team_material()
	process_mode = PROCESS_MODE_DISABLED

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
