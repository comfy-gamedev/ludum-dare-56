extends Node
class_name Unit

@export var team = Enums.Team.BLUE: set = set_team
@export var unit_type = "melee" # | "siege" | "ranged"
@export var max_health := 50
@export var attack_points = 10
@export var movement_speed = 75

var health := max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_team_material()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
