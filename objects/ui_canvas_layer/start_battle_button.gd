extends Button

func _ready() -> void:
	Globals.phase_changed.connect(_on_globals_phase_changed)
	Globals.changed.connect(_on_globals_changed)
	
	pressed.connect(_on_pressed)

func _on_globals_phase_changed() -> void:
	disabled = Globals.phase != Enums.Phase.BUILD
	visible = not disabled

func _on_globals_changed() -> void:
	disabled = Globals.cpu_acting or Globals.phase != Enums.Phase.BUILD

func _on_pressed() -> void:
	assert(Globals.phase == Enums.Phase.BUILD)
	Globals.phase = Enums.Phase.FIGHT
