class_name Upgrade
extends Resource

func get_label() -> String:
	push_error("NOT IMPLEMENTED")
	return "(unknown)"

func get_description() -> String:
	push_error("NOT IMPLEMENTED")
	return "(no description)"

func instantiate_preview() -> Node:
	push_error("NOT IMPLEMENTED")
	var s = Sprite2D.new()
	s.texture = preload("res://icon.png")
	s.material = preload("res://materials/team_blue.tres")
	return s

## async
func try_apply(cl: UICanvasLayer) -> bool:
	push_error("NOT IMPLEMENTED")
	return false
