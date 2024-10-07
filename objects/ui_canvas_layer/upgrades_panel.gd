extends Control

signal done()

const BLUEPRINTS = [
	#preload("res://blueprints/autocannon.tres"),
	preload("res://blueprints/barricade.tres"),
	preload("res://blueprints/buffer.tres"),
	preload("res://blueprints/extender.tres"),
	#preload("res://blueprints/farm.tres"),
	#preload("res://blueprints/goblin_cage.tres"),
	#preload("res://blueprints/goblin_spawner.tres"),
	#preload("res://blueprints/laser_turret.tres"),
	#preload("res://blueprints/mage_spawner.tres"),
	#preload("res://blueprints/rat_spawner.tres"),
	#preload("res://blueprints/repairer.tres"),
	#preload("res://blueprints/rock_turret.tres"),
	#preload("res://blueprints/shotgun_turret.tres"),
	#preload("res://blueprints/snake_spawner.tres"),
	#preload("res://blueprints/sniper_turret.tres"),
	#preload("res://blueprints/tesla_turret.tres"),
]

@export var ui_canvas_layer: UICanvasLayer
@export var hotbar: Control

@onready var panels = [
	%UpgradePanel1,
	%UpgradePanel2,
	%UpgradePanel3,
]

@onready var overlay: ColorRect = $Overlay
@onready var description: Label = $Description
@onready var sorry: Label = $Sorry

func _ready() -> void:
	for p in panels:
		p.chosen.connect(_on_panel_chosen.bind(p))
		p.mouse_entered.connect(_on_panel_mouse_entered.bind(p))
	
	var possible_upgrades = []
	for bp in BLUEPRINTS:
		var found = false
		for bp2 in Globals.player_hotbar:
			if bp2 == null:
				continue
			if bp2.name == bp.name:
				found = true
				break
		if found:
			continue
		
		var u = UpgradeBlueprint.new()
		u.blueprint = bp
		possible_upgrades.append(u)
	possible_upgrades.shuffle()
	
	for i in panels.size():
		if possible_upgrades.size() <= i:
			panels[i].queue_free()
			continue
		panels[i].upgrade = possible_upgrades[i]
	if not possible_upgrades:
		sorry.show()


func _on_panel_chosen(panel: Node) -> void:
	if await panel.upgrade.try_apply(ui_canvas_layer):
		done.emit()

func _on_panel_mouse_entered(panel: Node) -> void:
	description.text = panel.upgrade.get_description()
	description.visible_ratio = 0.0
	create_tween().tween_property(description, "visible_ratio", 1.0, 0.5)

## async
func choose_hotbar_slot() -> int:
	overlay.show()
	var i = await hotbar.hotbar_selected
	overlay.hide()
	return i

func _on_skip_button_pressed() -> void:
	done.emit()


func _on_cancel_button_pressed() -> void:
	hotbar.hotbar_selected.emit(-1)
