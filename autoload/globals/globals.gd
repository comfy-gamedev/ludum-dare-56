extends Node
## An empty global variable bag with a togglable debug overlay that displays all variables.
##
## Designed to hold simple global variables.
## A bad pattern, but in a game jam, sometimes you just need to get it done.
##
## Displays a debug overlay when the user hits the F1 key.
## All variables are displayed automatically.

## Emitted when any variable changes.
signal changed


## Example variable.
var player_money: int = 5:
	set(v): player_money = v; changed.emit()


## Reset all variables to their default state.
func reset():
	player_money = 5


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
