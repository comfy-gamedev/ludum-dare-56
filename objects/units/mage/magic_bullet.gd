extends Area2D

var team: Enums.Team = Enums.Team.BLUE
var velocity := Vector2(5, 0)
var damage := 10

func _ready() -> void:
	if team == Enums.Team.BLUE:
		collision_layer = 0
		collision_mask = 0b10100
	elif team == Enums.Team.RED:
		collision_layer = 0
		collision_mask = 0b01010


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Unit") or body.is_in_group("Building")) and team != body.team:
		body.hit(damage)
		queue_free()
