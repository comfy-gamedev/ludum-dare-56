class_name CpuAIParams
extends Resource

@export var fortification_blueprints: Array[Blueprint] = []
@export var turret_blueprints: Array[Blueprint] = []
@export var production_blueprints: Array[Blueprint] = []
@export var spawner_blueprints: Array[Blueprint] = []

## production/fortifications (-1) vs turrets/spawners (+1)
@export_range(-1.0, 1.0, 0.25) var militarism: float = 0.0

## fortifications (-1) vs production (+1)
@export_range(-1.0, 1.0, 0.25) var economics: float = 0.0

## turrets (-1) vs spawners (+1)
@export_range(-1.0, 1.0, 0.25) var aggression: float = 0.0

## liklihood of placing turrets/fortifications in front and spawners/production in rear
@export_range(0.0, 1.0, 0.25) var organization: float = 0.5
