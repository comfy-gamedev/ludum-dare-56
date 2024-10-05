extends Node2D
class_name Building

@export var team = "enemy"
@export var building_type = "turret"

var max_health := 50
var health := max_health
var reach := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit(damage_taken: float):
	health -= damage_taken
	if health <= 0:
		queue_free()
