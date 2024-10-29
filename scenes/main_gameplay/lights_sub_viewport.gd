extends SubViewport

@onready var world_sub_viewport: SubViewport = %WorldSubViewport

func _ready() -> void:
	size = world_sub_viewport.size
	RenderingServer.frame_pre_draw.connect(_on_pre_draw)

func _on_pre_draw() -> void:
	canvas_transform = world_sub_viewport.canvas_transform
