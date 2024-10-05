extends Node2D

var blueprint_preview: Node2D = null

@onready var camera_shake: CameraShake = $Camera2D/CameraShake

func _ready() -> void:
	var hb = Globals.player_hotbar
	hb[0] = preload("res://blueprints/goblin_spawner.tres")
	Globals.player_hotbar = hb
	Globals.selected_blueprint_changed.connect(_on_globals_selected_blueprint_changed)

func _process(delta: float) -> void:
	if !get_tree().get_nodes_in_group("Building").filter(func(x): return x.team == Enums.Team.BLUE):
		SceneGirl.change_scene("res://scenes/lose_screen/lose_screen.tscn")
	
	if is_instance_valid(blueprint_preview):
		var p = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
		p = p.snappedf(8)
		blueprint_preview.global_position = p
	
	if Globals.selected_blueprint and Input.is_action_just_pressed("build_plueprint"):
		assert(is_instance_valid(blueprint_preview))
		var s = Globals.selected_blueprint.spawned_scene.instantiate()
		s.position = blueprint_preview.position
		add_child(s)


func _on_globals_selected_blueprint_changed() -> void:
	if is_instance_valid(blueprint_preview):
		blueprint_preview.queue_free()
		blueprint_preview = null
	if Globals.selected_blueprint:
		blueprint_preview = Globals.selected_blueprint.hotbar_scene.instantiate()
		blueprint_preview.scale = Vector2.ONE
		blueprint_preview.modulate = Color(1, 1, 1, 0.5)
		add_child(blueprint_preview)
