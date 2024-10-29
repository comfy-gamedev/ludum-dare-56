extends Node2D

@export var team: Enums.Team: set = set_team

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	material = TeamMaterial.get_material(team)

func set_team(v: Enums.Team) -> void:
	if team == v: return
	team = v
	material = TeamMaterial.get_material(team)
