extends Label

func _ready() -> void:
	text = ("You won %s battle." if Globals.game_level == 1 else "You won %s battles.") % [Globals.game_level]
