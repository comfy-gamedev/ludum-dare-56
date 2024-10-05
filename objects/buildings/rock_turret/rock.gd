extends Node2D

var velocity := Vector2(5, 0)
var damage := 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Unit"):
		body.hit(damage)
		queue_free()
