extends Building

var target := Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var enemies := get_tree().get_nodes_in_group("Unit")
	var target = enemies.map(func(x): return x.global_position).max()
