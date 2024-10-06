extends Control

@onready var sun: Node2D = $Sun

@onready var _initial_position = position

func _ready() -> void:
	Globals.phase_changed.connect(_on_globals_phase_changed)
	position.y += size.y
	sun.position = Vector2(80.0 + 64.0, 48.0)

func _process(delta: float) -> void:
	if Globals.phase != Enums.Phase.FIGHT:
		return
	
	var t = Globals.day_time / Globals.DAY_DURATION * PI
	sun.position = Vector2(
		80.0 + -cos(t) * 64.0,
		48.0 + -sin(t) * 32.0)

func _on_globals_phase_changed() -> void:
	var target = _initial_position
	var ease = Tween.EASE_OUT
	
	match Globals.phase:
		Enums.Phase.BUILD:
			target = _initial_position + Vector2(0, 48)
			ease = Tween.EASE_IN
		Enums.Phase.FIGHT:
			pass
	
	create_tween().set_ease(ease).set_trans(Tween.TRANS_BACK) \
		.tween_property(self, "position", target, 0.25)
