class_name UpgradeBlueprint
extends Upgrade

@export var blueprint: Blueprint

func get_label() -> String:
	return blueprint.name

func get_description() -> String:
	return blueprint.description

func instantiate_preview() -> Node:
	return blueprint.hotbar_scene.instantiate()

## async
func try_apply(cl: UICanvasLayer) -> bool:
	var slot = await cl.choose_hotbar_slot()
	if slot == -1:
		return false
	var hb = Globals.player_hotbar.duplicate()
	hb[slot] = blueprint
	Globals.player_hotbar = hb
	return true
