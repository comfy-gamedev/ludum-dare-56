extends Node2D

@export var spawn_scene: PackedScene
@export_range(0.2, 10.0, 0.2) var spawn_interval: float = 4.0

var t: float = 0.0

func _ready() -> void:
	Globals.phase_changed.connect(_on_globals_phase_changed)

func _process(delta: float) -> void:
	t += delta
	if t >= spawn_interval:
		t -= spawn_interval
		spawn()

func spawn() -> void:
	var spawnee = spawn_scene.instantiate()
	get_parent().get_parent().add_child(spawnee)
	spawnee.global_position = global_position
	spawnee.team = get_parent().team

func _on_globals_phase_changed() -> void:
	t = 0
