class_name GridManager
extends Node2D

const CELL_SIZE = Vector2(16, 16)


var castles = Array[CastleGrid]

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func to_grid(pos: Vector2) -> Vector2i:
	return Vector2i((pos / CELL_SIZE).floor())

func add_castle(pos: Vector2, radius: int) -> void:
	var p = to_grid(pos)
	var c = CastleGrid.new(p, radius)
	castles.append(c)
	for y in range(p.y - radius, p.y + radius):
		for x in range(p.x - radius, p.y + radius):
			var cell_p = Vector2i(x, y)
			if cell_p.distance_squared_to(c) > radius*radius:
				continue
			for oc in castles:
				if cell_p in oc.cells:
					c.cells[cell_p] = oc.cells[cell_p]
					break
			if cell_p not in c.cells:
				var cell = GridCell.new(cell_p)
				c.cells[cell_p] = cell
				add_child(cell.highlight)

func can_place_building(pos: Vector2, size: Vector2i) -> bool:
	var p = to_grid(pos)
	for y in size.y:
		for x in size.x:
			var pp = p + Vector2i(x, y)
			var found = false
			for c in castles:
				if pp in c.cells:
					found = true
					break
			if not found:
				return false
	return true

func place_building(pos: Vector2, size: Vector2i, building: Variant) -> void:
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
	
	func _init(c: Vector2i, r: int) -> void:
		center = c
		radius = r
	

class GridCell extends RefCounted:
	var position: Vector2i
	var occupant: Variant: set = set_occupant
	var highlight: Node2D
	
	func _init(p: Vector2i) -> void:
		position = p
		highlight = Sprite2D.new()
		highlight.position = Vector2(position) * CELL_SIZE
		highlight.texture = preload("res://objects/grid/highlight_blue.png")
	
	func _notification(what):
		if what == NOTIFICATION_PREDELETE:
			highlight.queue_free()
	
	func set_occupant(v) -> void:
		occupant = v
		match v:
			null:
				highlight.texture = preload("res://objects/grid/highlight_red.png")
			_:
				highlight.texture = preload("res://objects/grid/highlight_blue.png")
				
