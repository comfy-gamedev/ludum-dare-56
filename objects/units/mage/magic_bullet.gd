extends Area2D

var team: Enums.Team = Enums.Team.BLUE: set = set_team
var velocity := Vector2(5, 0)
var damage := 10

func _ready() -> void:
	material = TeamMaterial.get_material(team)
	_update_collision_bits()

func _update_collision_bits() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = 1
		collision_mask = 0b10100
	elif team == Enums.Team.RED:
		collision_layer = 1
		collision_mask = 0b01010

func set_team(t: Enums.Team) -> void:
	if team == t:
		return
	team = t
	material = TeamMaterial.get_material(team)
	_update_collision_bits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Unit") or body.is_in_group("Building")) and team != body.team:
		body.hit(damage)
		queue_free()
