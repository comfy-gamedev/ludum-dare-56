extends Button

func _ready() -> void:
	toggled.connect(_on_toggled)

func _on_toggled(on: bool) -> void:
	AudioServer.set_bus_mute(0, on)
	icon = preload("res://assests/unmute.png") if on else preload("res://assests/mute.png")
