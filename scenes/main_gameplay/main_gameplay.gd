extends Node2D

const CASTLE = preload("res://objects/buildings/castle/castle.tscn")

@export var blue_castle_position: Vector2 = Vector2(6, 13) * 16
@export var red_castle_position: Vector2 = Vector2(30, 6) * 16

var blueprint_preview: Node2D = null

@onready var camera_shake: CameraShake = $Camera2D/CameraShake
@onready var night_effect: ColorRect = $EffectsCanvasLayer/NightEffect
@onready var grid_manager = $GridManager

func _ready() -> void:
	var hb = Globals.player_hotbar
	hb[0] = preload("res://blueprints/goblin_spawner.tres")
	Globals.player_hotbar = hb
	Globals.selected_blueprint_changed.connect(_on_globals_selected_blueprint_changed)
	Globals.phase_changed.connect(_on_globals_phase_changed)
	night_effect.transition(1.0)
	
	grid_manager.add_castle(blue_castle_position, 5, Enums.Team.BLUE)
	grid_manager.add_castle(red_castle_position, 5, Enums.Team.RED)
	
	var blue_castle = CASTLE.instantiate()
	blue_castle.team = Enums.Team.BLUE
	blue_castle.position = blue_castle_position - grid_manager.CELL_SIZE / 2.0
	blue_castle.bp_size = Vector2i(2, 2)
	add_child(blue_castle)
	grid_manager.place_building(blue_castle.position, Vector2i(2, 2), blue_castle, Enums.Team.BLUE)

	var red_castle = CASTLE.instantiate()
	red_castle.team = Enums.Team.RED
	red_castle.position = red_castle_position - grid_manager.CELL_SIZE / 2.0
	red_castle.bp_size = Vector2i(2, 2)
	add_child(red_castle)
	grid_manager.place_building(red_castle.position, Vector2i(2, 2), red_castle, Enums.Team.RED)

func _process(delta: float) -> void:
	if is_instance_valid(blueprint_preview):
		var p = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
		p = (p + grid_manager.CELL_SIZE / 2.0).snapped(grid_manager.CELL_SIZE) - grid_manager.CELL_SIZE / 2.0
		blueprint_preview.global_position = p
		var can_place = Globals.player_money >= Globals.selected_blueprint.cost and grid_manager.can_place_building(blueprint_preview.position, Globals.selected_blueprint.size, Enums.Team.BLUE)
		var mat = preload("res://materials/team_blue.tres") if can_place else preload("res://materials/invalid.tres")
		var sprs = blueprint_preview.find_children("*", "Sprite2D") + blueprint_preview.find_children("*", "AnimatedSprite2D")
		if blueprint_preview is Sprite2D or blueprint_preview is AnimatedSprite2D:
			sprs.append(blueprint_preview)
		for s in sprs:
			if s.material != null:
				s.material = mat
	
	var team_buildings = {
		Enums.Team.BLUE: [],
		Enums.Team.RED: [],
	}
	
	for b in get_tree().get_nodes_in_group("Castle"):
		team_buildings[b.team].append(b)
	
	#if team_buildings[Enums.Team.RED].size() == 0:
		#SceneGirl.change_scene("res://scenes/win_screen/win_screen.tscn")
	#elif team_buildings[Enums.Team.BLUE].size() == 0:
		#SceneGirl.change_scene("res://scenes/lose_screen/lose_screen.tscn")
	
	if Globals.phase == Enums.Phase.FIGHT:
		Globals.day_time += delta
		if Globals.day_time >= Globals.DAY_DURATION:
			Globals.phase = Enums.Phase.BUILD
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build_blueprint"):
		if Globals.selected_blueprint:
			assert(is_instance_valid(blueprint_preview))
			get_viewport().set_input_as_handled()
			if Globals.player_money >= Globals.selected_blueprint.cost and grid_manager.can_place_building(blueprint_preview.position, Globals.selected_blueprint.size, Enums.Team.BLUE):
				Globals.player_money -= Globals.selected_blueprint.cost
				var s = Globals.selected_blueprint.spawned_scene.instantiate()
				s.position = blueprint_preview.position
				s.bp_size = Globals.selected_blueprint.size
				add_child(s)
				grid_manager.place_building(s.position, s.bp_size, s, Enums.Team.BLUE)
	if event.is_action_pressed("cancel_blueprint"):
		if Globals.selected_blueprint:
			get_viewport().set_input_as_handled()
			Globals.selected_blueprint = null

func _on_globals_selected_blueprint_changed() -> void:
	if is_instance_valid(blueprint_preview):
		blueprint_preview.queue_free()
		blueprint_preview = null
	if Globals.selected_blueprint:
		blueprint_preview = Globals.selected_blueprint.hotbar_scene.instantiate()
		blueprint_preview.scale = Vector2.ONE
		blueprint_preview.modulate = Color(1, 1, 1, 0.5)
		add_child(blueprint_preview)
		grid_manager.reveal(Enums.Team.BLUE)
	else:
		grid_manager.unreveal(Enums.Team.BLUE)

func _on_day_timer_timeout() -> void:
	Globals.phase = Enums.Phase.BUILD
	Globals.player_money += Globals.player_income

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
