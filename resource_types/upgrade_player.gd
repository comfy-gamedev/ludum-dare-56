class_name UpgradePlayer
extends Upgrade

enum Kind {
	STARTING_MANA,
	PASSIVE_INCOME,
}

var kind: Kind

func get_label() -> String:
	match kind:
		Kind.STARTING_MANA:
			return "Start Mana +2"
		Kind.PASSIVE_INCOME:
			return "Turn Mana +1"
		_:
			return "Unknown"

func get_description() -> String:
	match kind:
		Kind.STARTING_MANA:
			return "Gain more mana at the very start of a war."
		Kind.PASSIVE_INCOME:
			return "Gain more mana each night."
		_:
			return "Unknown"

func instantiate_preview() -> Node:
	var s = Sprite2D.new()
	match kind:
		Kind.STARTING_MANA:
			s.texture = preload("res://assests/manap1.png")
		Kind.PASSIVE_INCOME:
			s.texture = preload("res://assests/manap2.png")
	return s

## async
func try_apply(cl: UICanvasLayer) -> bool:
	match kind:
		Kind.STARTING_MANA:
			Globals.blue_starting_mana += 2
		Kind.PASSIVE_INCOME:
			Globals.blue_income += 1
	return true
