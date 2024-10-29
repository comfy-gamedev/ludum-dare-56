extends Node

var t: float = 0.0
var a: Array[float] = []

func _ready() -> void:
	a.resize(8 * 8)
	for i in 8 * 8:
		a[i] = float(i) / float(8 * 8)
	_regenerate()


func _process(delta: float) -> void:
	t += delta / Engine.time_scale
	if t > 0.2:
		t = fmod(t, 0.2)
		_regenerate()

func _regenerate() -> void:
	a.shuffle()
	var img := Image.create(8, 8, false, Image.FORMAT_L8)
	for i in 8 * 8:
		img.set_pixel(i % 8, i / 8, Color(a[i], 0, 0, 0))
	RenderingServer.global_shader_parameter_set("dither_matrix", ImageTexture.create_from_image(img))
