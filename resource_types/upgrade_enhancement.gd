class_name UpgradeEnhancement
extends Upgrade

enum Kind {
	DISCOUNT,
}

var kind: Kind

func get_label() -> String:
	match kind:
		Kind.DISCOUNT:
			return "Discount"
		_:
			return "Unknown"

func get_description() -> String:
	match kind:
		Kind.DISCOUNT:
			return "Reduce the cost of a blueprint."
		_:
			return "Unknown"

func instantiate_preview() -> Node:
	var s = Sprite2D.new()
	match kind:
		Kind.DISCOUNT:
			s.texture = preload("res://assests/discount.png")
	return s

## async
func try_apply(cl: UICanvasLayer) -> bool:
	var found = false
	for bp in Globals.player_hotbar:
		if bp.cost > 1:
			found = true
			break
	if not found:
		return false
	var slot = await cl.choose_hotbar_slot()
	if slot == -1 or Globals.player_hotbar[slot] == null:
		return false
	if Globals.player_hotbar[slot].cost <= 1:
		return false
	var b = Globals.player_hotbar[slot].duplicate()
	b.cost -= 1
	var hb = Globals.player_hotbar.duplicate()
	hb[slot] = b
	Globals.player_hotbar = hb
	return true
