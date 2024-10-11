extends Node2D

const GOBLIN = preload("res://objects/units/goblin/goblin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		if "on_day" in c:
			c.on_day()
	for i in 0:
		var g = GOBLIN.instantiate()
		g.position = ($Goblin if randi() % 2 else $Goblin2).position + Vector2.from_angle(randf_range(0, TAU)) * randf_range(0.1,5.0)
		g.team = Enums.Team.RED
		add_child(g)
