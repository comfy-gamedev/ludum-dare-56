@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var x = Node
	print((Component as GDScript).source_code)
