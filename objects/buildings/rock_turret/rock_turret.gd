extends Node2D

var max_health := 50
var health := max_health
var target := Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Dude")
	var target = enemies.map(func(x): return x.global_position).max()

func hit(damage_taken: float):
	health -= damage_taken
