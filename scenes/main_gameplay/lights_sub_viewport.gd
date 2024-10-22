extends SubViewport

func _ready() -> void:
	size = %WorldSubViewport.size
	RenderingServer.frame_pre_draw.connect(_on_pre_draw)

func _on_pre_draw() -> void:
	pass
	#canvas_transform = %WorldSubViewport.canvas_transform
