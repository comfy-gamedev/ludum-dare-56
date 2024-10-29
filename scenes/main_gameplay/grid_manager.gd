class_name GridManager
extends Node2D

const CELL_SIZE = Vector2(16, 16)

var cells: Dictionary = {}

var revealed: Array[Enums.Team]

var _next_id: int = 1

static func to_grid(pos: Vector2) -> Vector2i:
	return Vector2i((pos / CELL_SIZE).floor())

static func get_cell_center(pos: Vector2i) -> Vector2:
	return Vector2(pos) * CELL_SIZE + CELL_SIZE * 0.5

func reveal(team: Enums.Team) -> void:
	if team in revealed:
		return
	revealed.append(team)
	for p: Vector2i in cells:
		var c: GridCell = cells[p]
		if c.has_claim(team):
			c.reveal()

func unreveal(team: Enums.Team) -> void:
	if team not in revealed:
		return
	revealed.erase(team)
	for p: Vector2i in cells:
		var c: GridCell = cells[p]
		if c.has_claim(team):
			c.unreveal()

func has_claim(team: Enums.Team, where: Vector2) -> bool:
	var cell: GridCell = cells.get(where, null)
	if cell == null:
		return false
	return cell.has_claim(team)

func get_occupant(where: Vector2) -> Node2D:
	var cell: GridCell = cells.get(where, null)
	if cell == null:
		return null
	return cell.occupant

func can_construct_blueprint(team: Enums.Team, blueprint: Blueprint, where: Vector2) -> bool:
	var pos := to_grid(where)
	
	for y in range(pos.y, pos.y + blueprint.size.y):
		for x in range(pos.x, pos.x + blueprint.size.x):
			var cell := _get_or_create_cell(Vector2i(x, y))
			if cell.occupant != null:
				return false
			if not cell.has_claim(team):
				return false
	
	return true

func construct_blueprint(team: Enums.Team, blueprint: Blueprint, where: Vector2) -> Node2D:
	var pos := to_grid(where)
	
	var should_reveal := team in revealed
	
	for offset: Vector2i in _get_territory_offsets(blueprint.size):
		var cell := _get_or_create_cell(pos + offset)
		cell.add_claim(team)
		if should_reveal:
			cell.reveal()
	
	var building: Node2D = blueprint.spawned_scene.instantiate()
	building.name = blueprint.name + str(_next_id)
	building.team = team
	building.position = get_cell_center(pos)
	building.bp_size = blueprint.size
	
	_next_id += 1
	
	get_parent().add_child(building)
	
	for y in range(pos.y, pos.y + blueprint.size.y):
		for x in range(pos.x, pos.x + blueprint.size.x):
			_get_or_create_cell(Vector2i(x, y)).occupant = building
	
	return building

func destroy_building(building: Node2D) -> void:
	var pos := to_grid(building.position)
	
	for y in range(pos.y, pos.y + building.bp_size.y):
		for x in range(pos.x, pos.x + building.bp_size.x):
			var cell := _get_or_create_cell(Vector2i(x, y))
			if cell.occupant == building:
				cell.occupant = null
	
	for offset: Vector2i in _get_territory_offsets(building.bp_size):
		_get_or_create_cell(pos + offset).remove_claim(building.team)
	
	building.queue_free()

func get_available_cells(team: Enums.Team) -> Array[Vector2]:
	var result: Array[Vector2]
	for p: Vector2i in cells:
		var c: GridCell = cells[p]
		if c.occupant != null:
			continue
		if not c.has_claim(team):
			continue
		result.append(get_cell_center(p))
	return result

func _get_or_create_cell(where: Vector2i) -> GridCell:
	var cell: GridCell = cells.get(where, null)
	if cell == null:
		cell = GridCell.new(where, self)
		cells[where] = cell
	return cell

func _get_territory_offsets(bp_size: Vector2i) -> Array[Vector2i]:
	var results: Array[Vector2i]
	var rect := Rect2i(Vector2.ZERO, bp_size)
	var ext := mini(bp_size.x, bp_size.y)
	for y in range(-ext, bp_size.y + ext):
		for x in range(-ext, bp_size.x + ext):
			var p := Vector2i(x, y)
			if rect.has_point(p):
				results.append(p)
			else:
				var dx := -x if x < 0 else x - bp_size.x + 1 if x > bp_size.x else 0
				var dy := -y if y < 0 else y - bp_size.y + 1 if y > bp_size.y else 0
				var mn := mini(dx, dy)
				var mx := maxi(dx, dy)
				var dist := floori(mn * 1.5) + (mx - mn)
				if dist <= ext:
					results.append(p)
	return results

class GridCell extends RefCounted:
	var position: Vector2i
	var occupant: Variant: set = set_occupant
	var highlight: Node2D
	var claims: Dictionary
	
	func _init(p: Vector2i, highlight_owner: Node) -> void:
		position = p
		highlight = Sprite2D.new()
		highlight.position = GridManager.get_cell_center(p)
		highlight.visible = false
		highlight.texture = preload("res://objects/grid/highlight_blue.png")
		highlight_owner.add_child(highlight)
	
	func _notification(what):
		if what == NOTIFICATION_PREDELETE:
			if is_instance_valid(highlight):
				highlight.queue_free()
	
	func set_occupant(v) -> void:
		occupant = v
		match v:
			null:
				highlight.texture = preload("res://objects/grid/highlight_red.png")
			_:
				highlight.texture = preload("res://objects/grid/highlight_blue.png")
	
	func add_claim(team: Enums.Team) -> void:
		claims[team] = claims.get_or_add(team, 0) + 1
	
	func remove_claim(team: Enums.Team) -> void:
		claims[team] -= 1
	
	func has_claim(team: Enums.Team) -> bool:
		return claims.get(team, 0) > 0
	
	func reveal() -> void:
		highlight.visible = true
	
	func unreveal() -> void:
		highlight.visible = false
