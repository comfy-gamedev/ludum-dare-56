@tool
extends EditorPlugin

const Importer = preload("res://addons/palette_sprite_importer/importer.gd")

var importer: EditorImportPlugin

func _enter_tree() -> void:
	importer = Importer.new()
	add_import_plugin(importer)

func _exit_tree() -> void:
	remove_import_plugin(importer)
	importer = null
