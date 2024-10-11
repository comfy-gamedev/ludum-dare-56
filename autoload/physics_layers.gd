extends Node

var BLUE_BUILDINGS: int
var RED_BUILDINGS: int
var BLUE_UNITS: int
var RED_UNITS: int

var ANY_BLUE: int
var ANY_RED: int
var ANY_BUILDINGS: int
var ANY_UNITS: int

var ANY_TARGET: int

func _ready() -> void:
	for i in 32:
		var layer_name: String = ProjectSettings.get("layer_names/2d_physics/layer_%s" % [i + 1])
		var const_name = layer_name.to_snake_case().to_upper()
		if const_name in self:
			self[const_name] = 1 << i
	
	ANY_BLUE = BLUE_BUILDINGS | BLUE_UNITS
	ANY_RED = RED_BUILDINGS | RED_UNITS
	ANY_BUILDINGS = BLUE_BUILDINGS | RED_BUILDINGS
	ANY_UNITS = BLUE_UNITS | RED_UNITS
	
	ANY_TARGET = ANY_BLUE | ANY_RED
