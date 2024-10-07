extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.rounds_changed.connect(_on_rounds_changed)
	text = "Round : " + str(Globals.rounds)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#text = "Mana : " + str(Globals.blue_money)

func _on_rounds_changed() -> void:
	text = "Round : " + str(Globals.rounds)
	if Globals.rounds < 6:
		add_theme_color_override("font_color", Color.WHITE)
	elif Globals.rounds > 5 && Globals.rounds < 9:
		add_theme_color_override("font_color", Color.YELLOW)
	elif Globals.rounds > 8:
		add_theme_color_override("font_color", Color.RED)
