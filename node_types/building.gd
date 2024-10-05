class_name Building
extends Node2D

@export var team: Enums.Team = Enums.Team.BLUE: set = set_team
@export var building_type: Enums.BuildingType = Enums.BuildingType.UNSPECIFIED

@export var max_health := 50
@export var reach := 0

var health := max_health

func _ready() -> void:
	_update_team_material()

func hit(damage_taken: float):
	health -= damage_taken
	if health <= 0:
		queue_free()

func set_team(v: Enums.Team) -> void:
	if team == v:
		return
	team = v
	if is_inside_tree():
		_update_team_material()

func _update_team_material():
	var sprite = get_node_or_null(^"AnimatedSprite2D")
	
	if sprite:
		match team:
			Enums.Team.BLUE:
				sprite.material = preload("res://materials/team_blue.tres")
			Enums.Team.RED:
				sprite.material = preload("res://materials/team_red.tres")
