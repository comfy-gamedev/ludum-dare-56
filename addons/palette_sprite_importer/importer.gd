@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "apples.palette_sprite_importer"

func _get_visible_name():
	return "Palette Sprite"

func _get_recognized_extensions():
	return ["png"]

func _get_save_extension():
	return "res"

func _get_resource_type():
	return "Texture2D"

func _get_preset_count():
	return Presets.size()

func _get_preset_name(preset_index):
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"

func _get_import_options(path, preset_index):
	match preset_index:
		Presets.DEFAULT:
			return [{
				"name": "palette_image",
				"default_value": "res://palette.png",
				"property_hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "Image",
			}]
		_:
			return []

func _get_option_visibility(path, option_name, options):
	return true

func _get_import_order() -> int:
	return 0

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	save_path += ".res"
	var srcimg = Image.load_from_file(ProjectSettings.globalize_path(source_file))
	var img = Image.create(srcimg.get_width(), srcimg.get_height(), false, Image.FORMAT_LA8)
	var palette = Image.load_from_file(ProjectSettings.globalize_path(options.palette_image))
	var palette_colors = {}
	for i: int in palette.get_width():
		palette_colors[palette.get_pixel(i, 0)] = (i + 0.5) / float(palette.get_width())
	for y: int in srcimg.get_height():
		for x: int in srcimg.get_width():
			var c = srcimg.get_pixel(x, y)
			var i = palette_colors.get(c, 0)
			img.set_pixel(x, y, Color(i, 0, 0, c.a))
	var texture = ImageTexture.create_from_image(img)
	ResourceSaver.save(texture, save_path)
	return OK
