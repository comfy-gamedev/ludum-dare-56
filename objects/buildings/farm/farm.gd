extends Building

var squish_amount = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale = (Vector2(1, 1) + (Vector2(abs(cos(squish_amount) / 2), abs(sin(squish_amount))) * (squish_amount / 8))).snappedf(0.25) #>:(
	squish_amount -= delta * 8
	squish_amount = max(squish_amount, 0)

func _on_timer_timeout() -> void:
	match team:
		Enums.Team.BLUE:
			Globals.blue_temp_income += 1
		Enums.Team.RED:
			Globals.red_temp_income += 1
		_:
			breakpoint
	squish_amount = 2 * PI
