extends Building

var squish_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	if team == Enums.Team.RED:
		$Sprite2D.material = red_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < max_health / 2.0:
		smoke.emitting = true
	else:
		smoke.emitting = false
	
	scale = Vector2(1, 1) + (Vector2(abs(cos(squish_amount) / 2), abs(sin(squish_amount))) * (squish_amount / 8))
	squish_amount -= delta * 4
	squish_amount = max(squish_amount, 0)

func _on_timer_timeout() -> void:
	Globals.player_money += 1
	squish_amount = 2 * PI
