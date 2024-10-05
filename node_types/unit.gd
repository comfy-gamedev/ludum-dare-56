extends Node
class_name Unit

@export var team = "friendly" # | "enemy"
@export var unit_type = "melee" # | "siege" | "ranged"
@export var max_health := 50
@export var attack_points = 10
@export var movement_speed = 75

var health := max_health

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
