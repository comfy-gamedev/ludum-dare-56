extends Node2D

const CASTLE = preload("res://objects/buildings/castle/castle.tscn")

var blueprint_preview: Node2D = null

@onready var camera_shake: CameraShake = $Camera2D/CameraShake
@onready var night_effect: ColorRect = $EffectsCanvasLayer/NightEffect
@onready var grid_manager: GridManager = $GridManager

func _ready() -> void:
	var hb = Globals.player_hotbar
	hb[0] = preload("res://blueprints/goblin_spawner.tres")
	Globals.player_hotbar = hb
	Globals.selected_blueprint_changed.connect(_on_globals_selected_blueprint_changed)
	Globals.phase_changed.connect(_on_globals_phase_changed)
	night_effect.transition(1.0)
	
	grid_manager.add_castle(Vector2(
	
	CASTLE.instantiate()
	grid_manager.place_building(s.position, Globals.selected_blueprint.size, s)

func _process(delta: float) -> void:
	if is_instance_valid(blueprint_preview):
		var p = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
		p = p.snappedf(16)
		blueprint_preview.global_position = p
	
	var team_buildings = {
		Enums.Team.BLUE: [],
		Enums.Team.RED: [],
	}
	
	for b in get_tree().get_nodes_in_group("Castle"):
		team_buildings[b.team].append(b)
	
	if team_buildings[Enums.Team.RED].size() == 0:
		SceneGirl.change_scene("res://scenes/win_screen/win_screen.tscn")
	elif team_buildings[Enums.Team.BLUE].size() == 0:
		SceneGirl.change_scene("res://scenes/lose_screen/lose_screen.tscn")
	
	if Globals.phase == Enums.Phase.FIGHT:
		Globals.day_time += delta
		if Globals.day_time >= Globals.DAY_DURATION:
			Globals.phase = Enums.Phase.BUILD
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build_plueprint"):
		if Globals.selected_blueprint:
			assert(is_instance_valid(blueprint_preview))
			get_viewport().set_input_as_handled()
			if grid_manager.can_place_building(blueprint_preview.position, Globals.selected_blueprint.size):
				var s = Globals.selected_blueprint.spawned_scene.instantiate()
				s.position = blueprint_preview.position
				add_child(s)
				grid_manager.place_building(s.position, Globals.selected_blueprint.size, s)

func _on_globals_selected_blueprint_changed() -> void:
	if is_instance_valid(blueprint_preview):
		blueprint_preview.queue_free()
		blueprint_preview = null
	if Globals.selected_blueprint:
		blueprint_preview = Globals.selected_blueprint.hotbar_scene.instantiate()
		blueprint_preview.scale = Vector2.ONE
		blueprint_preview.modulate = Color(1, 1, 1, 0.5)
		add_child(blueprint_preview)

func _on_day_timer_timeout() -> void:
	Globals.phase = Enums.Phase.BUILD

func _on_globals_phase_changed() -> void:
	match Globals.phase:
		Enums.Phase.BUILD:
			for u in get_tree().get_nodes_in_group("Unit"):
				u.queue_free()
			for b: Building in get_tree().get_nodes_in_group("Building"):
				b.on_night()
		Enums.Phase.FIGHT:
			for b: Building in get_tree().get_nodes_in_group("Building"):
				b.on_day()
			Globals.day_time = 0.0
			Globals.selected_blueprint = null
