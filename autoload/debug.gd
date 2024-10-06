extends Node

@onready var ot = get_window().title

func _ready() -> void:
	if OS.has_feature("release"):
		queue_free()
		return

func _physics_process(delta: float) -> void:
	get_window().title = ot + (" (%s fps)" % Engine.get_frames_per_second())
