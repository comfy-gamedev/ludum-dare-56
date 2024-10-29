@tool
extends Node2D

@export var spriteframes: SpriteFrames

var step: int = 0: set = set_step # floori((step - 2) / 4) == round

var _tween: Tween

func _ready() -> void:
	if not Engine.is_editor_hint():
		Globals.rounds_changed.connect(_on_rounds_changed)

func _on_rounds_changed() -> void:
	if _tween and _tween.is_running():
		_tween.custom_step(INF)
	_tween = create_tween()
	_tween.tween_property(self, "step", Globals.rounds * 4, 1.0)

func set_step(v: int) -> void:
	if step == v: return
	step = v
	queue_redraw()

func _draw() -> void:
	var x := 0.0
	for i in range(1, 11):
		var anim := str(i)
		var s := i * 4
		var frame := clampi(step - s + 2, 0, 4)
		var texture := spriteframes.get_frame_texture(anim, frame)
		draw_texture(texture, Vector2(x, 0))
		x += texture.get_width()
