extends Node2D

var team: Enums.Team = Enums.Team.BLUE: set = set_team
var velocity := Vector2(5, 0)
var damage := 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	material = TeamMaterial.get_material(team)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func set_team(v: Enums.Team) -> void:
	if team == v: return
	team = v
	material = TeamMaterial.get_material(team)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Unit") and team != body.team:
		body.hit(damage)
		queue_free()
