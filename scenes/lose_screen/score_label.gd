extends Label

func _ready() -> void:
	text = "Rounds Survived : " + str(Globals.game_level - 1)
