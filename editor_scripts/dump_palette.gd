@tool
extends EditorScript

const PALETTE_FILE = "res://palette.png"

func _run() -> void:
	var pal := Image.load_from_file(ProjectSettings.globalize_path(PALETTE_FILE))
	print("const PALETTE = {")
	for i in pal.get_width():
		print("\tCOLOR", i, " = Color(\"", pal.get_pixel(i, 0).to_html(false), "\"),")
	print("}")
	print("const INDEXED_PALETTE = {")
	for i in pal.get_width():
		var f = (float(i) + 0.5) / pal.get_width()
		print("\tCOLOR", i, " = Color(%s, %s, %s, 1.0)," % [f, f, f])
	print("}")
