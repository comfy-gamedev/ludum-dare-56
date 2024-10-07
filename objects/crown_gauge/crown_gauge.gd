extends Control

@onready var crowns = [
	$CrownWidget1,
	$CrownWidget2,
	$CrownWidget3,
	$CrownWidget4,
	$CrownWidget5,
	$CrownWidget6,
	$CrownWidget7,
	$CrownWidget8,
	$CrownWidget9,
	$CrownWidget10,
]

@onready var plus_label: Label = $PlusLabel

func _ready() -> void:
	for i in range(min(Globals.game_level,10)):
		crowns[i].active = true
	
	if Globals.game_level < 10:
		plus_label.hide()
	else:
		plus_label.text = "+" + str(Globals.game_level - 10)
	
