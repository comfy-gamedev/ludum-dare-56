extends Building

@export var spawn_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	if team == Enums.Team.RED:
		$AnimatedSprite2D.material = red_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var spawnee = spawn_scene.instantiate()
	get_parent().add_child(spawnee)
	spawnee.global_position = global_position
	spawnee.team = team
