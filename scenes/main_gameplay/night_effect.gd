@tool
extends ColorRect

@export_range(0.0, 1.0, 0.1) var time: float = 0.0: set = set_time

@export var lightmap: Texture2D

func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.phase_changed.connect(_on_globals_phase_changed)
	(material as ShaderMaterial).set_shader_parameter("lower_bound", 1.0 - time)
	(material as ShaderMaterial).set_shader_parameter("lightmap", lightmap)
	visible = not is_zero_approx(time)

func set_time(v: float) -> void:
	if time == v:
		return
	time = v
	(material as ShaderMaterial).set_shader_parameter("lower_bound", 1.0 - time)
	(material as ShaderMaterial).set_shader_parameter("lightmap", lightmap)
	visible = not is_zero_approx(time)

func transition(t: float) -> Signal:
	return create_tween().tween_property(self, "time", t, 1.0).finished

func _on_globals_phase_changed() -> void:
	match Globals.phase:
		Enums.Phase.BUILD:
			transition(1.0)
		Enums.Phase.FIGHT:
			transition(0.0)
