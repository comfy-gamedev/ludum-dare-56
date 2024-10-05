class_name GenericSignaller
extends Node3D
## A small script which simply provides a generic event signal, useful for animations in imported scenes.

## A generic signal.
##
## [param what]: name of event that occurred.
## [param data]: event data.
signal event(what: StringName, data: Variant)

## Emits [signal event] with the given params.
func emit(what: StringName, data: Variant = null) -> void:
	event.emit(what, data)
