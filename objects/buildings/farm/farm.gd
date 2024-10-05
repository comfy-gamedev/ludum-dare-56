extends Building

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = 50
	health = max_health
	if team == Enums.Team.RED:
		$Sprite2D.material = red_material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	#gain money/mana
	#play squish animation? put a floating +1 in front of it? play fireworks?
	pass # Replace with function body.
