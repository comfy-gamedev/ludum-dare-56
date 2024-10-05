@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var r = EditorInterface.get_edited_scene_root()
	var s = r.get_node_or_null("Smoke")
	if s:
		var ns = preload("res://objects/smoke/smoke.tscn").instantiate()
		ns.transform = s.transform
		s.free()
		r.add_child(ns)
		ns.owner = r
