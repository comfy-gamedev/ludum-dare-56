extends PanelContainer

@export var disabled: bool = false

var current_hotbar: Array[Blueprint] = [null, null, null, null, null, null]

var hotbar_nodes: Array[Node] = [null, null, null, null, null, null]

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
	for i in 6:
		color_rects[i].gui_input.connect(_on_color_rect_gui_input.bind(i))

func _input(event: InputEvent) -> void:
	if disabled:
		return
	for i in 6:
		if event.is_action_pressed("hotbar_" + str(i + 1)):
			get_viewport().set_input_as_handled()
			_select_hotbar(i)

func _on_color_rect_gui_input(event: InputEvent, i: int) -> void:
	if disabled:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			_select_hotbar(i)

func _select_hotbar(i: int) -> void:
	Globals.selected_blueprint = Globals.player_hotbar[i]

func _on_globals_selected_blueprint_changed() -> void:
	hightlight.visible = Globals.selected_blueprint != null
	var i = Globals.player_hotbar.find(Globals.selected_blueprint)
	hightlight.position = Vector2(10 + 20 * i, 10)

func _on_globals_player_hotbar_changed() -> void:
	for i in 6:
		if current_hotbar[i] != Globals.player_hotbar[i]:
			if is_instance_valid(hotbar_nodes[i]):
				hotbar_nodes[i].queue_free()
				hotbar_nodes[i] = null
			current_hotbar[i] = Globals.player_hotbar[i]
			if current_hotbar[i]:
				hotbar_nodes[i] = current_hotbar[i].hotbar_scene.instantiate()
				hotbar_nodes[i].position = Vector2(10 + 20 * i, 10)
				add_child(hotbar_nodes[i])

func _on_globals_phase_changed() -> void:
	var target = _initial_position
	var ease = Tween.EASE_OUT
	
	match Globals.phase:
		Enums.Phase.BUILD:
			pass
		Enums.Phase.FIGHT:
			target = _initial_position + Vector2(0, 20)
			ease = Tween.EASE_IN
	
	create_tween().set_ease(ease).set_trans(Tween.TRANS_BACK) \
		.tween_property(self, "position", target, 0.25)
	
	disabled = Globals.phase != Enums.Phase.BUILD
