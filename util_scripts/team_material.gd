class_name TeamMaterial
extends RefCounted

const TEAM_MATERIALS = [
	preload("res://materials/team_blue.tres"),
	preload("res://materials/team_red.tres"),
]

static func get_material(team: Enums.Team) -> Material:
	return TEAM_MATERIALS[team]
