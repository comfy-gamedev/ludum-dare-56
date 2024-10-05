extends Building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 200
	health = max_health
	if team == Enums.Team.RED:
		$Sprite2D.material = red_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < max_health / 2.0:
		smoke.emitting = true
	else:
		smoke.emitting = false
