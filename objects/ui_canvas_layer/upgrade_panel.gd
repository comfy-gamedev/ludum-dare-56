extends Control

signal chosen()

@export var upgrade: Upgrade: set = set_upgrade

var preview: Node2D

@onready var label: Label = $Label
@onready var center: Control = $Center

func set_upgrade(u: Upgrade) -> void:
	if upgrade == u:
		return
	upgrade = u
	if is_inside_tree():
		_update()

func _ready() -> void:
	_update()

func _update() -> void:
	if is_instance_valid(preview):
		preview.queue_free()
		preview = null
	if not upgrade:
		label.text = ""
	else:
		label.text = upgrade.get_label()
		preview = upgrade.instantiate_preview()
		preview.position = center.get_rect().get_center()
		add_child(preview)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			chosen.emit()
