class_name CpuPlayer
extends Node

@export var team: Enums.Team = Enums.Team.RED
@export var params: CpuAIParams
@export var grid: GridManager

func _ready() -> void:
	Globals.red_starting_mana = params.starting_money
	Globals.red_income = params.passive_income
	Globals.phase_changed.connect(_on_globals_phase_changed)

func build_phase() -> void:
	Globals.cpu_acting = true
	
	await get_tree().create_timer(0.5).timeout
	
	while true:
		if not _try_place_building():
			break
		await get_tree().create_timer(0.5).timeout
	
	Globals.cpu_acting = false

func _try_place_building() -> bool:
	var affordable_fortification_blueprints: Array[Blueprint] = params.fortification_blueprints.filter(_can_afford)
	var affordable_turret_blueprints: Array[Blueprint] = params.turret_blueprints.filter(_can_afford)
	var affordable_production_blueprints: Array[Blueprint] = params.production_blueprints.filter(_can_afford)
	var affordable_spawner_blueprints: Array[Blueprint] = params.spawner_blueprints.filter(_can_afford)
	
	var militarism_blueprints: Array[Blueprint] = _choose(affordable_turret_blueprints, affordable_spawner_blueprints, params.militarism)
	var economics_blueprints: Array[Blueprint] = _choose(affordable_fortification_blueprints, affordable_production_blueprints, params.economics)
	
	var final_blueprints: Array[Blueprint] = _choose(economics_blueprints, militarism_blueprints, params.aggression)
	
	if not final_blueprints:
		return false
	
	var bp = final_blueprints.pick_random()
	
	return _try_construct_blueprint(bp)

func _try_construct_blueprint(bp: Blueprint) -> bool:
	var cells = grid.get_available_cells(team)
	#cells.shuffle()
	
	var chosen_cell = null
	
	if randf() > params.organization:
		cells.shuffle()
		for c in cells:
			if grid.can_place_building(c, bp.size, team):
				chosen_cell = c
				break
	else:
		cells.sort_custom(func(a, b): 
			var weighted_a = 0
			var weighted_b = 0
			if bp.category == Enums.BlueprintCategory.TURRET || bp.category == Enums.BlueprintCategory.FORTIFICATION:
				weighted_a -= (a / 16).x
				weighted_a += (a / 16).y / 2
				weighted_b -= (b / 16).x
				weighted_b += (b / 16).y / 2
			else:
				weighted_a += (a / 16).x
				weighted_a -= (a / 16).y / 2
				weighted_b += (b / 16).x
				weighted_b -= (b / 16).y / 2
			
			weighted_a += 1 if !grid.can_place_building(((a / 16) + Vector2(1, 0) * 16), Vector2i(1, 1), team) else 0
			weighted_a += 1 if !grid.can_place_building(((a / 16) + Vector2(-1, 0) * 16), Vector2i(1, 1), team) else 0
			weighted_a += 1 if !grid.can_place_building(((a / 16) + Vector2(0, 1) * 16), Vector2i(1, 1), team) else 0
			weighted_a += 1 if !grid.can_place_building(((a / 16) + Vector2(0, -1) * 16), Vector2i(1, 1), team) else 0
			
			weighted_b += 1 if !grid.can_place_building(((b / 16) + Vector2(1, 0) * 16), Vector2i(1, 1), team) else 0
			weighted_b += 1 if !grid.can_place_building(((b / 16) + Vector2(-1, 0) * 16), Vector2i(1, 1), team) else 0
			weighted_b += 1 if !grid.can_place_building(((b / 16) + Vector2(0, 1) * 16), Vector2i(1, 1), team) else 0
			weighted_b += 1 if !grid.can_place_building(((b / 16) + Vector2(0, -1) * 16), Vector2i(1, 1), team) else 0
			
			return weighted_a > weighted_b
		)
		chosen_cell = cells[0] #OPTIMAL
	
	if chosen_cell == null:
		return false
	
	var building = bp.spawned_scene.instantiate()
	building.team = team
	building.position = chosen_cell + grid.CELL_SIZE / 2.0
	building.bp_size = bp.size
	get_parent().add_child(building)
	
	MusicMan.sfx(preload("res://assests/SFX/build-building2.wav"), "build")
	
	grid.place_building(building.position, bp.size, building, team)
	
	Globals.red_money -= bp.cost
	
	return true

func _can_afford(bp: Blueprint) -> bool:
	return bp != null and Globals.red_money >= bp.cost

func _choose(a, b, f: float) -> Variant:
	if not a:
		return b
	elif not b:
		return a
	else:
		return b if randf_range(-1.0, 1.0) <= f else a
	

func _on_globals_phase_changed() -> void:
	if Globals.phase == Enums.Phase.BUILD:
		build_phase()
