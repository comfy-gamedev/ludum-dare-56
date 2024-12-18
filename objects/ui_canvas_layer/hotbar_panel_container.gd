extends PanelContainer

signal hotbar_selected(i: int)

@export var disabled: bool = false

var current_hotbar: Array[Blueprint] = [null, null, null, null, null, null]

var hotbar_nodes: Array[Node] = [null, null, null, null, null, null]
var hotbar_costs: Array[Label] = [null, null, null, null, null, null]

@onready var hightlight: Sprite2D = $Hightlight

@onready var color_rects = [
	$HBoxContainer/ColorRect,
	$HBoxContainer/ColorRect2,
	$HBoxContainer/ColorRect3,
	$HBoxContainer/ColorRect4,
	$HBoxContainer/ColorRect5,
	$HBoxContainer/ColorRect6,
]

@onready var _initial_position = position

func _ready() -> void:
	hightlight.visible = false
	Globals.player_hotbar_changed.connect(_on_globals_player_hotbar_changed)
	Globals.selected_blueprint_changed.connect(_on_globals_selected_blueprint_changed)
	Globals.phase_changed.connect(_on_globals_phase_changed)
	Globals.blue_mana_changed.connect(_on_globals_blue_mana_changed)
	for i in 6:
		color_rects[i].gui_input.connect(_on_color_rect_gui_input.bind(i))
	
	hotbar_costs[0] = $HBoxContainer/ColorRect/Label
	hotbar_costs[1] = $HBoxContainer/ColorRect2/Label
	hotbar_costs[2] = $HBoxContainer/ColorRect3/Label
	hotbar_costs[3] = $HBoxContainer/ColorRect4/Label
	hotbar_costs[4] = $HBoxContainer/ColorRect5/Label
	hotbar_costs[5] = $HBoxContainer/ColorRect6/Label
	
	_update_slots()
	

func _input(event: InputEvent) -> void:
	if disabled:
		return
	for i in 6:
		if event.is_action_pressed("hotbar_" + str(i + 1)):
			get_viewport().set_input_as_handled()
			if Globals.phase == Enums.Phase.BUILD:
				_select_hotbar(i)
			else:
				hotbar_selected.emit(i)

func _unhandled_input(event: InputEvent) -> void:
	if Globals.phase != Enums.Phase.STANDBY:
		return
	if event.is_action_pressed("cancel_blueprint"):
		get_viewport().set_input_as_handled()
		hotbar_selected.emit(-1)

func _on_color_rect_gui_input(event: InputEvent, i: int) -> void:
	if disabled:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			if Globals.phase == Enums.Phase.BUILD:
				_select_hotbar(i)
			else:
				hotbar_selected.emit(i)

func _select_hotbar(i: int) -> void:
	Globals.selected_blueprint = Globals.player_hotbar[i]

func _on_globals_selected_blueprint_changed() -> void:
	hightlight.visible = Globals.selected_blueprint != null
	var i = Globals.player_hotbar.find(Globals.selected_blueprint)
	hightlight.position = Vector2(10 + 18 * i, 10)

func _on_globals_player_hotbar_changed() -> void:
	_update_slots()

func _update_slots() -> void:
	for i in 6:
		if current_hotbar[i] != Globals.player_hotbar[i]:
			if is_instance_valid(hotbar_nodes[i]):
				hotbar_nodes[i].queue_free()
				hotbar_nodes[i] = null
				hotbar_costs[i].text = ""
			current_hotbar[i] = Globals.player_hotbar[i]
			if current_hotbar[i]:
				hotbar_nodes[i] = current_hotbar[i].hotbar_scene.instantiate()
				hotbar_nodes[i].position = Vector2(10 + 18 * i, 10)
				hotbar_costs[i].text = str(current_hotbar[i].cost)
				add_child(hotbar_nodes[i])

func _on_globals_phase_changed() -> void:
	var target = _initial_position
	var ease = Tween.EASE_OUT
	
	match Globals.phase:
		Enums.Phase.BUILD:
			pass
		Enums.Phase.FIGHT:
			target = _initial_position + Vector2(0, 24)
			ease = Tween.EASE_IN
	
	create_tween().set_ease(ease).set_trans(Tween.TRANS_BACK) \
		.tween_property(self, "position", target, 0.25)
	
	disabled = Globals.phase != Enums.Phase.BUILD

func _on_globals_blue_mana_changed() -> void:
	for i in 6:
		if hotbar_costs[i].text != "":
			if Globals.blue_mana >= int(hotbar_costs[i].text):
				hotbar_costs[i].add_theme_color_override("font_color", Enums.COLOR_GREEN3)
			else:
				hotbar_costs[i].add_theme_color_override("font_color", Enums.COLOR_PINK3)
