extends Building

var giant_scene := preload("res://objects/units/giant_goblin/giant_goblin.tscn")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	super()
	Globals.phase_changed.connect(_on_globals_phase_changed)
	

func _on_globals_phase_changed() -> void:
	if Globals.phase == Enums.Phase.FIGHT:
		await get_tree().create_timer(randf_range(0.0, 1.0)).timeout
		sprite_2d.play("default")
		await sprite_2d.animation_finished
		var giant = giant_scene.instantiate()
		giant.global_position = global_position
		giant.team = team
		get_parent().add_child(giant)
	else:
		sprite_2d.frame = 0
