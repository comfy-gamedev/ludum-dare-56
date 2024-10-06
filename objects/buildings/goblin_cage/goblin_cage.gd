extends Building

var giant_scene := preload("res://objects/units/giant_goblin/giant_goblin.tscn")

func _ready() -> void:
	Globals.phase_changed.connect(_on_globals_phase_changed)
	



func _on_globals_phase_changed() -> void:
	if Globals.phase == Enums.Phase.FIGHT:
		var giant = giant_scene.instantiate()
		get_parent().add_child(giant)
		giant.global_position = global_position
		giant.team = team
