class_name CpuPlayer
extends Node

@export var team: Enums.Team = Enums.Team.RED
@export var params: CpuAIParams
@export var grid: GridManager

func _ready() -> void:
	Globals.red_starting_mana = params.starting_mana
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
	
	if not cells:
		return false
	
	var chosen_cell = null
	
	if randf() > params.organization:
		cells.shuffle()
		for c in cells:
			if grid.can_construct_blueprint(team, bp, c):
				chosen_cell = c
				break
	else:
		#var rr = [Rect2i(cells[0] / grid.CELL_SIZE, Vector2i.ONE)]
		
		var weighted_cells = cells.map(func (a: Vector2):
			var tile := a / grid.CELL_SIZE
			var weight: float = 0
			
			#rr[0] = rr[0].expand(tile)
			
			if bp.category in [Enums.BlueprintCategory.TURRET, Enums.BlueprintCategory.FORTIFICATION]:
				weight -= tile.x - tile.y / 2
			else:
				weight += tile.x - tile.y / 2
			
			for d: Vector2 in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
				var p := (tile + d) * grid.CELL_SIZE
				if not grid.has_claim(team, p):
					continue
				var o := grid.get_occupant(p)
				if not o or o.team != team:
					continue
				weight += 1
			
			return { cell = a, tile = tile, weight = weight }
		)
		
		var by_weight_desc = func(a, b): return a.weight > b.weight
		
		weighted_cells.sort_custom(by_weight_desc)
		weighted_cells.resize(weighted_cells.bsearch_custom(weighted_cells[0], by_weight_desc, false))
		weighted_cells.shuffle()
		
		chosen_cell = weighted_cells[0].cell #OPTIMAL
		
		#var rect = rr[0]
		#var map = []
		#map.resize(rect.size.y + 1)
		#for i in rect.size.y + 1:
			#map[i] = []
			#map[i].resize(rect.size.x + 1)
			#map[i].fill("[   . ]")
		#
		#for wc in weighted_cells:
			#map[wc.tile.y - rect.position.y][wc.tile.x - rect.position.x] = "[%+02.1f]" % [wc.weight]
		#
		#var str = ""
		#for m in map:
			#str += "".join(m) + "\n"
		#
		#print("WEIGHTS: ")
		#print(str)
	
	if chosen_cell == null:
		breakpoint
		return false
	
	grid.construct_blueprint(team, bp, chosen_cell)
	
	MusicMan.sfx(preload("res://assests/SFX/build-building2.wav"), "build")
	
	Globals.red_mana -= bp.cost
	
	return true

func _can_afford(bp: Blueprint) -> bool:
	return bp != null and Globals.red_mana >= bp.cost

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
