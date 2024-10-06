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

const DAY_DURATION = 15.0

signal player_hotbar_changed()
var player_hotbar: Array[Blueprint] = [null, null, null, null, null, null]:
	set(v): player_hotbar = v; changed.emit(); player_hotbar_changed.emit()

signal selected_blueprint_changed()
var selected_blueprint: Blueprint = null:
	set(v): selected_blueprint = v; changed.emit(); selected_blueprint_changed.emit()

var player_money: int = 5:
	set(v): player_money = v; changed.emit()

signal phase_changed()
var phase: Enums.Phase = Enums.Phase.BUILD:
	set(v): phase = v; changed.emit(); phase_changed.emit()


var day_time: float = 0.0


## Reset all variables to their default state.
func reset():
	player_hotbar = [null, null, null, null, null, null]
	selected_blueprint = null
	player_money = 5
	phase = Enums.Phase.BUILD


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
