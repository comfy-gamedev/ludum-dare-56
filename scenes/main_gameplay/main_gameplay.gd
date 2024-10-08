extends Node2D

const CASTLE = preload("res://objects/buildings/castle/castle.tscn")

const BP_LEVELS = [
	{ min_lvl = 2, cat = "production", bp = preload("res://blueprints/farm.tres") },
	{ min_lvl = 3, cat = "fortification", bp = preload("res://blueprints/repairer.tres") },
	{ min_lvl = 1, cat = "fortification", bp = preload("res://blueprints/barricade.tres") },
	{ min_lvl = 2, cat = "fortification", bp = preload("res://blueprints/brambles.tres") },
	{ min_lvl = 6, cat = "fortification", bp = preload("res://blueprints/autocannon.tres") },
	{ min_lvl = 5, cat = "fortification", bp = preload("res://blueprints/buffer.tres") },
	{ min_lvl = 4, cat = "fortification", bp = preload("res://blueprints/extender.tres") },
	{ min_lvl = 3, cat = "turret", bp = preload("res://blueprints/laser_turret.tres") },
	{ min_lvl = 1, cat = "turret", bp = preload("res://blueprints/rock_turret.tres") },
	{ min_lvl = 2, cat = "turret", bp = preload("res://blueprints/shotgun_turret.tres") },
	{ min_lvl = 3, cat = "turret", bp = preload("res://blueprints/sniper_turret.tres") },
	{ min_lvl = 4, cat = "turret", bp = preload("res://blueprints/tesla_turret.tres") },
	{ min_lvl = 2, cat = "turret", bp = preload("res://blueprints/goblin_cage.tres") },
	{ min_lvl = 2, cat = "spawner", bp = preload("res://blueprints/bomber_spawner.tres") },
	{ min_lvl = 1, cat = "spawner", bp = preload("res://blueprints/goblin_spawner.tres") },
	{ min_lvl = 1, cat = "spawner", bp = preload("res://blueprints/mage_spawner.tres") },
	{ min_lvl = 3, cat = "spawner", bp = preload("res://blueprints/rat_spawner.tres") },
	{ min_lvl = 4, cat = "spawner", bp = preload("res://blueprints/snake_spawner.tres") },
]

@export var blue_castle_position: Vector2 = Vector2(6, 13) * 16
@export var red_castle_position: Vector2 = Vector2(30, 6) * 16

var blueprint_preview: Node2D = null

var red_castle: Node

@onready var camera_shake: CameraShake = $Camera2D/CameraShake
@onready var night_effect: ColorRect = $EffectsCanvasLayer/NightEffect
@onready var grid_manager = $GridManager

func _ready() -> void:
	Globals.game_level += 1
	
	# Player Setup
	
	# Enemy Setup
	
	Globals.red_money = 0
	
	var cpu = CpuPlayer.new()
	cpu.team = Enums.Team.RED
	cpu.grid = grid_manager
	cpu.params = CpuAIParams.new()
	
	var num_blueprints = clampi(2 + Globals.game_level / 2, 2, 6)
	var allowed_discounts = Globals.game_level / 2
	
	var allowed_bps = []
	for bplvl in BP_LEVELS:
		if bplvl.min_lvl > Globals.game_level:
			continue
		allowed_bps.append(bplvl.bp)
	
	allowed_bps.shuffle()
	allowed_bps.resize(num_blueprints)
	
	for i in allowed_bps.size():
		allowed_bps[i] = allowed_bps[i].duplicate()
	
	for i in allowed_discounts:
		allowed_bps[i % allowed_bps.size()].cost = maxi(allowed_bps[i % allowed_bps.size()].cost - 1, 1)
	
	for bp: Blueprint in allowed_bps:
		match bp.category:
			Enums.BlueprintCategory.FORTIFICATION:
				cpu.params.fortification_blueprints.append(bp)
			Enums.BlueprintCategory.TURRET:
				cpu.params.turret_blueprints.append(bp)
			Enums.BlueprintCategory.SPAWNER:
				cpu.params.spawner_blueprints.append(bp)
			Enums.BlueprintCategory.PRODUCTION:
				cpu.params.production_blueprints.append(bp)
	
	if cpu.params.spawner_blueprints.is_empty():
		cpu.params.spawner_blueprints.append(preload("res://blueprints/goblin_spawner.tres"))
	
	cpu.params.aggression = randf_range(-0.8, 0.8)
	cpu.params.economics = randf_range(-0.8, 0.8)
	cpu.params.militarism = randf_range(-0.8, 0.8)
	cpu.params.organization = randf_range(0.2, 0.8)
	
	cpu.params.starting_money = Globals.game_level + randi_range(0, 1) + (10 if Globals.game_level % 10 == 0 else 0)
	cpu.params.passive_income = 2 + ((2 * Globals.game_level) / 3)
	
	add_child(cpu)
	
	
	Globals.blue_money = Globals.blue_starting_mana
	Globals.red_money = Globals.red_starting_mana
	Globals.blue_temp_income = Globals.blue_income
	Globals.red_temp_income = Globals.red_income
	
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

	red_castle = CASTLE.instantiate()
	red_castle.team = Enums.Team.RED
	red_castle.position = red_castle_position - grid_manager.CELL_SIZE / 2.0
	red_castle.bp_size = Vector2i(2, 2)
	add_child(red_castle)
	grid_manager.place_building(red_castle.position, Vector2i(2, 2), red_castle, Enums.Team.RED)
	
	Globals.phase = Enums.Phase.BUILD

func _process(delta: float) -> void:
	if is_instance_valid(blueprint_preview):
		var p = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
		p = (p + grid_manager.CELL_SIZE / 2.0).snapped(grid_manager.CELL_SIZE) - grid_manager.CELL_SIZE / 2.0
		blueprint_preview.global_position = p
		var can_place = Globals.blue_money >= Globals.selected_blueprint.cost and grid_manager.can_place_building(blueprint_preview.position, Globals.selected_blueprint.size, Enums.Team.BLUE)
		var mat = preload("res://materials/team_blue.tres") if can_place else preload("res://materials/invalid.tres")
		var sprs = blueprint_preview.find_children("*", "Sprite2D") + blueprint_preview.find_children("*", "AnimatedSprite2D")
		if blueprint_preview is Sprite2D or blueprint_preview is AnimatedSprite2D:
			sprs.append(blueprint_preview)
		for s in sprs:
			if s.material != null:
				s.material = mat
	
	if Globals.phase == Enums.Phase.FIGHT:
		Globals.day_time += delta
		if Globals.day_time >= Globals.DAY_DURATION:
			Globals.phase = Enums.Phase.BUILD
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("build_blueprint"):
		if Globals.selected_blueprint:
			assert(is_instance_valid(blueprint_preview))
			get_viewport().set_input_as_handled()
			if Globals.blue_money >= Globals.selected_blueprint.cost and grid_manager.can_place_building(blueprint_preview.position, Globals.selected_blueprint.size, Enums.Team.BLUE):
				Globals.blue_money -= Globals.selected_blueprint.cost
				var s = Globals.selected_blueprint.spawned_scene.instantiate()
				s.position = blueprint_preview.position
				s.bp_size = Globals.selected_blueprint.size
				add_child(s)
				MusicMan.sfx(preload("res://assests/SFX/build-building2.wav"), "build")
				grid_manager.place_building(s.position, s.bp_size, s, Enums.Team.BLUE)
	if event.is_action_pressed("cancel_blueprint"):
		if Globals.selected_blueprint:
			get_viewport().set_input_as_handled()
			Globals.selected_blueprint = null
	if OS.has_feature("debug"):
		if event.is_action_pressed("debug_2"):
			red_castle.queue_free()
			await get_tree().process_frame
			Globals.phase = Enums.Phase.BUILD

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


func _on_globals_phase_changed() -> void:
	match Globals.phase:
		Enums.Phase.BUILD:
			MusicMan.music(preload("res://assests/Music/building-time.ogg"), 0.5)
			for u in get_tree().get_nodes_in_group("Unit"):
				u.queue_free()
			for p in get_tree().get_nodes_in_group("Projectile"):
				p.queue_free()
			for b in get_tree().get_nodes_in_group("Building"):
				b.on_night()
			Globals.blue_money += Globals.blue_temp_income
			Globals.red_money += Globals.red_temp_income
			Globals.blue_temp_income = 0
			Globals.red_temp_income = 0
			
			var castles = get_tree().get_nodes_in_group("Castle")
			if !castles.any(func(x): return x.team == Enums.Team.RED):
				if Globals.game_level == 10:
					SceneGirl.change_scene("res://scenes/win_screen/win_screen.tscn")
				else:
					Globals.upgrades_queued = [Enums.Upgrades.ANYTHING]
					SceneGirl.change_scene("res://scenes/upgrade_screen/upgrade_screen.tscn")
				Globals.phase = Enums.Phase.STANDBY
				Globals.rounds = 0
			elif !castles.any(func(x): return x.team == Enums.Team.BLUE):
				Globals.game_level -= 1
				SceneGirl.change_scene("res://scenes/lose_screen/lose_screen.tscn")
				Globals.phase = Enums.Phase.STANDBY
			
			if Globals.rounds >= 10:
				Globals.game_level -= 1
				SceneGirl.change_scene("res://scenes/lose_screen/lose_screen.tscn")
				Globals.phase = Enums.Phase.STANDBY
			
		Enums.Phase.FIGHT:
			MusicMan.music(preload("res://assests/Music/battle-time.ogg"), 0.5)
			for b in get_tree().get_nodes_in_group("Building"):
				b.on_day()
			Globals.day_time = 0.0
			Globals.selected_blueprint = null
			Globals.rounds += 1
			Globals.blue_temp_income = Globals.blue_income
			Globals.red_temp_income = Globals.red_income
