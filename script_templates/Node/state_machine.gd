extends Node

func _ready() -> void:
	_goto("idle")

func _always_process(delta: float) -> void:
	pass

func _always_physics_process(delta: float) -> void:
	pass

#region State idle
func _state_idle_enter() -> void:
	pass

func _state_idle_process(delta: float) -> void:
	pass

func _state_idle_physics_process(delta: float) -> void:
	pass

func _state_idle_exit() -> void:
	pass
#endregion


#region State machine core
# do not touch please
var _states: Dictionary
var _current_state: StringName
func __opt_func(n: StringName) -> Callable:
	return Callable(self, n) if self.has_method(n) else Callable()
func _add_state(state_name: String) -> void:
	_states[state_name] = {
		process = __opt_func("_state" + state_name + "_process"),
		physics_process = __opt_func("_state" + state_name + "_physics_process"),
		enter = __opt_func("_state" + state_name + "_enter"),
		exit = __opt_func("_state" + state_name + "_exit") }
	if _states[state_name].values().count(Callable()) == 4:
		push_warning("State %s has no state functions! Typo?" % [state_name])
		breakpoint
func _goto(state_name: StringName) -> void:
	if _current_state and _states[_current_state].exit: _states[_current_state].exit()
	_current_state = state_name
	if not _current_state: return
	if not _current_state in _states: _add_state(_current_state)
	if _current_state and _states[_current_state].enter: _states[_current_state].enter()
func _process(delta: float) -> void:
	if &"_always_process" in self: (self as Variant)._always_process(delta)
	if _current_state and _states[_current_state].process: _states[_current_state].process(delta)
func _physics_process(delta: float) -> void:
	if &"_always_physics_process" in self: (self as Variant)._always_physics_process(delta)
	if _current_state and _states[_current_state].process: _states[_current_state].physics_process(delta)
#endregion
