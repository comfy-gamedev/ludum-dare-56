extends Building

@onready var grid_manager = $"../GridManager"
@onready var id = get_instance_id()

func _ready() -> void:
	grid_manager.add_castle(global_position, 3, team, id)

func hit(damage_taken: float):
	health -= damage_taken
	MusicMan.sfx(preload("res://assests/SFX/hit.wav"), "hit", 1)
	if health <= 0:
		MusicMan.sfx(preload("res://assests/SFX/destroy-building.wav"), "destroy")
		grid_manager.remove_castle(id)
		queue_free()
