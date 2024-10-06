extends Node2D

@export var radius: float = 32.0
@export var sub_viewport: SubViewport

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var light: Node2D = $CanvasLayer/Light

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas_layer.custom_viewport = sub_viewport

func _process(delta: float) -> void:
	light.global_transform = global_transform
