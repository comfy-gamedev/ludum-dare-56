extends Node

@onready var label: Label = %Label

func _ready() -> void:
	SceneGirl.load_progress.connect(_on_scene_girl_load_progress)


func _on_scene_girl_load_progress(value: float) -> void:
	label.text = "Loading... %s%%" % roundi(value * 100.0)
