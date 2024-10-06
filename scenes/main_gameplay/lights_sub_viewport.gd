extends SubViewport

func _ready() -> void:
	size = get_parent().get_viewport().size
	RenderingServer.frame_pre_draw.connect(_on_pre_draw)

func _on_pre_draw() -> void:
	canvas_transform = get_parent().get_viewport().canvas_transform
