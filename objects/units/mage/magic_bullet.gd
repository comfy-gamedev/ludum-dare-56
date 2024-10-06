extends Node2D

var team: Enums.Team = Enums.Team.BLUE
var velocity := Vector2(5, 0)
var damage := 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Unit") or body.is_in_group("Building")) and team != body.team:
		body.hit(damage)
		queue_free()
