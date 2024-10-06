class_name GridManager
extends Node2D

const CELL_SIZE = Vector2(16, 16)


var castles: Array[CastleGrid]

var revealed: Array[Enums.Team]

func reveal(team: Enums.Team) -> void:
	if team in revealed:
		return
	revealed.append(team)
	for c in castles:
		if c.team != team:
			continue
		for p in c.cells:
			c.cells[p].reveal()

func unreveal(team: Enums.Team) -> void:
	if team not in revealed:
		return
	revealed.erase(team)
	for c in castles:
		if c.team != team:
			continue
		for p in c.cells:
			c.cells[p].unreveal()

func to_grid(pos: Vector2) -> Vector2i:
	return Vector2i((pos / CELL_SIZE).floor())

func add_castle(pos: Vector2, radius: int, team: Enums.Team) -> void:
	var p = to_grid(pos)
	var c = CastleGrid.new(p, radius, team)
	castles.append(c)
	var revealed = team in revealed
	for y in range(p.y - radius, p.y + radius):
		for x in range(p.x - radius, p.x + radius):
			var cell_p = Vector2i(x, y)
			if (Vector2(cell_p) + Vector2(0.5, 0.5)).distance_squared_to(Vector2(p)) > radius*radius:
				continue
			for oc in castles:
				if oc.team != team:
					continue
				if cell_p in oc.cells:
					c.cells[cell_p] = oc.cells[cell_p]
					break
			if cell_p not in c.cells:
				var cell = GridCell.new(cell_p)
				c.cells[cell_p] = cell
				add_child(cell.highlight)
			if revealed:
				c.cells[cell_p].reveal()

func can_place_building(pos: Vector2, size: Vector2i, team: Enums.Team) -> bool:
	var p = to_grid(pos)
	for y in size.y:
		for x in size.x:
			var pp = p + Vector2i(x, y)
			var found = false
			for c in castles:
				if c.team != team:
					continue
				if pp in c.cells:
					found = true
					break
			if not found:
				return false
	return true

func place_building(pos: Vector2, size: Vector2i, building: Variant, team: Enums.Team) -> void:
	var p = to_grid(pos)
	for y in size.y:
		for x in size.x:
			var pp = p + Vector2i(x, y)
			var found = false
			for c in castles:
				if pp in c.cells:
					found = true
					if building != null:
						assert(c.cells[pp].occupant == null)
					else:
						assert(c.cells[pp].occupant != null)
					c.cells[pp].occupant = building
					break
			assert(found)

class CastleGrid extends RefCounted:
	var center: Vector2i
	var radius: int
	var cells: Dictionary
	var team: Enums.Team
	
	func _init(c: Vector2i, r: int, t: Enums.Team) -> void:
		center = c
		radius = r
		team = t
	

class GridCell extends RefCounted:
	var position: Vector2i
	var occupant: Variant: set = set_occupant
	var highlight: Node2D
	
	var _reveals: int
	
	func _init(p: Vector2i) -> void:
		position = p
		highlight = Sprite2D.new()
		highlight.position = Vector2(position) * CELL_SIZE
		highlight.centered = false
		highlight.visible = false
		highlight.texture = preload("res://objects/grid/highlight_blue.png")
	
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
	
	func reveal() -> void:
		_reveals += 1
		highlight.visible = true
	
	func unreveal() -> void:
		assert(_reveals > 0)
		_reveals -= 1
		highlight.visible = _reveals > 0
