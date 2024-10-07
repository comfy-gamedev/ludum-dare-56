class_name UICanvasLayer
extends CanvasLayer

signal upgrade_done()

const UPGRADES_PANEL = preload("res://objects/ui_canvas_layer/upgrades_panel.tscn")

@export var is_upgrade_screen: bool = false

var upgrades_panel: Control

@onready var hotbar_panel_container: PanelContainer = $Control/HotbarPanelContainer
@onready var start_battle_button: Button = $Control/StartBattleButton
@onready var ff_button: Button = $Control/FFButton
@onready var mana_label: Control = $Control/ManaLabel
@onready var round_label: Label = $Control/RoundLabel

func _ready() -> void:
	if is_upgrade_screen:
		mana_label.hide()
		round_label.hide()
		upgrades_panel = UPGRADES_PANEL.instantiate()
		upgrades_panel.ui_canvas_layer = self
		upgrades_panel.hotbar = hotbar_panel_container
		$Control.add_child(upgrades_panel)
		upgrades_panel.done.connect(_on_upgrades_panel_done)
		start_battle_button.queue_free()
	else:
		Globals.phase_changed.connect(_on_phase_changed)

func _on_upgrades_panel_done() -> void:
	upgrades_panel.queue_free()
	upgrade_done.emit()

## async
func choose_hotbar_slot() -> int:
	return await upgrades_panel.choose_hotbar_slot()

func _on_phase_changed() -> void:
	if Globals.phase != Enums.Phase.FIGHT:
		Engine.time_scale = 1.0
		ff_button.hide()
	else:
		ff_button.text = "FF >>"
		ff_button.show()

func _on_ff_button_pressed() -> void:
	if Engine.time_scale == 1.0:
		ff_button.text = "FF <"
		Engine.time_scale = 2.0
	else:
		ff_button.text = "FF >>"
		Engine.time_scale = 1.0
