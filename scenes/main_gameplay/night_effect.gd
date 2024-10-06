@tool
extends ColorRect

@export_range(0.0, 1.0, 0.1) var time: float = 0.0: set = set_time

const PALETTES = [
	preload("res://palette.png"),
	preload("res://palette_night_transition.png"),
	preload("res://palette_night_transition2.png"),
	preload("res://palette_night.png"),
]

func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.phase_changed.connect(_on_globals_phase_changed)

func set_time(v: float) -> void:
	if time == v:
		return
	time = v
	var palette = PALETTES[clamp(float(PALETTES.size()) * time, 0, PALETTES.size() - 1)]
	(material as ShaderMaterial).set_shader_parameter("output_palette", palette)

func transition(t: float) -> Signal:
	return create_tween().tween_property(self, "time", t, 1.0).finished

func _on_globals_phase_changed() -> void:
	match Globals.phase:
		Enums.Phase.BUILD:
			transition(1.0)
		Enums.Phase.FIGHT:
			transition(0.0)
