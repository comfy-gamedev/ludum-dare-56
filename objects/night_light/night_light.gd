extends Node2D

@export var radius: float = 32.0
@export var sub_viewport: SubViewport

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var light: Node2D = $CanvasLayer/Light
@onready var timer: Timer = $Timer

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	canvas_layer.custom_viewport = sub_viewport
	timer.start(randf_range(0.1, 0.2))
	light.global_transform = global_transform

func _process(delta: float) -> void:
	light.global_transform = global_transform

func _on_timer_timeout() -> void:
	var f = randf_range(1.0, 1.1)
	light.flicker = move_toward(light.flicker, f, 0.05)
	timer.start(randf_range(0.3, 0.4))
