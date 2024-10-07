extends Node
## An empty global variable bag with a togglable debug overlay that displays all variables.
##
## Designed to hold simple global variables.
## A bad pattern, but in a game jam, sometimes you just need to get it done.
##
## Displays a debug overlay when the user hits the F1 key.
## All variables are displayed automatically.

## Emitted when any variable changes.
signal changed()

const DAY_DURATION = 25.0

signal player_hotbar_changed()
var player_hotbar: Array[Blueprint] = [preload("res://blueprints/goblin_spawner.tres"), preload("res://blueprints/rock_turret.tres"), null, null, null, null]:
	set(v): player_hotbar = v; changed.emit(); player_hotbar_changed.emit()

signal selected_blueprint_changed()
var selected_blueprint: Blueprint = null:
	set(v): selected_blueprint = v; changed.emit(); selected_blueprint_changed.emit()

var blue_starting_mana: int = 0
var blue_income: int = 4
var blue_money: int = 0:
	set(v): blue_money = v; changed.emit()

var red_starting_mana: int = 0
var red_income: int = 5
var red_money: int = 0:
	set(v): red_money = v; changed.emit()

signal phase_changed()
var phase: Enums.Phase = Enums.Phase.STANDBY:
	set(v): phase = v; changed.emit(); phase_changed.emit()

var cpu_acting: bool = false:
	set(v): cpu_acting = v; changed.emit()

var game_level: int = 0

var day_time: float = 0.0

func _ready() -> void:
	reset()

## Reset all variables to their default state.
func reset():
	player_hotbar = [preload("res://blueprints/goblin_spawner.tres"), preload("res://blueprints/rock_turret.tres"), null, null, null, null]
	selected_blueprint = null
	blue_starting_mana = 0
	blue_income = 4
	blue_money = 0
	red_starting_mana = 0
	red_income = 4
	red_money = 0
	game_level = 0
	day_time = 0.0
	cpu_acting = false
	phase = Enums.Phase.STANDBY


#region Debug overlay
var _overlay
func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed:
		match event.physical_keycode:
			KEY_F1:
				if not _overlay:
					_overlay = load("res://autoload/globals/globals_overlay.tscn").instantiate()
					get_parent().add_child(_overlay)
				else:
					_overlay.visible = not _overlay.visible
#endregion
