@tool
class_name MotionInterpolator2D
extends Node2D
## Provides physics interpolation and damped motion to its child node.
##
## The child node's transform will be fully controlled by this node while it is enabled.

## Interpolation mode.
enum MotionMode {
	## Applies linear physics interpolation.
	PHYSICS_INTERPOLATION,
	## Applies a smooth damping interpolation.
	SMOOTH_DAMP,
}

## Process function.
enum ProcessFunc {
	## Update transforms during idle frame processing.
	FRAME,
	## Update transforms during physics frame processing.
	PHYSICS,
}

## If not enabled, this node behaves like an unscripted Node2D.
@export var enabled: bool = true

## Interpolation mode. See [enum MotionMode].
@export var motion_mode: MotionMode = MotionMode.PHYSICS_INTERPOLATION:
	set(v):
		motion_mode = v
		notify_property_list_changed()
		update_configuration_warnings()

## If true, the child node's inital relative transform is kept.
@export var keep_initial_offset: bool = true

@export_group("Smoothing", "smoothing")

## Smothing factor for positional motion.
@export_range(0.0, 1.0, 0.01) var smoothing_position: float = 0.5

## Smothing factor for rotation and scale motion.
@export_range(0.0, 1.0, 0.01) var smoothing_rotation: float = 0.5

## Scales the power applied to the smoothing parameters.
## Useful for keeping the smoothing parameters easily editable in the inspector.
@export_range(0.1, 100.0, 0.1) var smoothing_power_scale: float = 10.0

@export_group("")

## Process function. See [enum ProcessFunc].
## [member MotionMode.PHYSICS_INTERPOLATION] requires [member ProcessFunc.FRAME].
@export var process_func: ProcessFunc = ProcessFunc.FRAME:
	set(v): process_func = v; update_configuration_warnings()


var _offset_transform: Transform2D

var _physics_interpolation_previous_xform: Transform2D
var _physics_interpolation_current_xform: Transform2D

var _smooth_damp_child_global_xform: Transform2D

func _ready():
	if process_priority == 0:
		process_priority = 1
	if process_physics_priority == 0:
		process_physics_priority = process_priority
	
	if Engine.is_editor_hint():
		return
	
	if get_child_count() != 1:
		push_error("MotionInterpolator2D: must have exactly 1 child.")
	
	if get_child_count() == 0:
		return
	
	var child := get_child(0) as Node2D
	
	if not child:
		push_error("MotionInterpolator2D: child must be a Node2D.")
		return
	
	if keep_initial_offset:
		_offset_transform = global_transform.inverse() * child.global_transform
	
	_physics_interpolation_current_xform = global_transform
	_physics_interpolation_previous_xform = _physics_interpolation_current_xform
	
	_smooth_damp_child_global_xform = child.global_transform

func _process(delta:float):
	if Engine.is_editor_hint():
		return
	
	if process_func == ProcessFunc.FRAME:
		_process_func(delta)

func _physics_process(delta: float):
	if Engine.is_editor_hint():
		return
	
	if process_func == ProcessFunc.PHYSICS:
		_process_func(delta)
	
	if motion_mode == MotionMode.PHYSICS_INTERPOLATION:
		_update_physics_interpolation_transforms.call_deferred()

func _update_physics_interpolation_transforms() -> void:
	_physics_interpolation_previous_xform = _physics_interpolation_current_xform
	_physics_interpolation_current_xform = global_transform * _offset_transform

func _process_func(delta: float):
	if not enabled:
		return
	
	if get_child_count() != 1:
		return
	
	var child: Node2D = get_child(0) as Node2D
	
	if not child:
		return
	
	match motion_mode:
		MotionMode.SMOOTH_DAMP:
			var target_xform := global_transform * _offset_transform
			var position_t := 1.0 - pow(smoothing_position, delta * smoothing_power_scale)
			var rotation_t := 1.0 - pow(smoothing_rotation, delta * smoothing_power_scale)
			
			var result_origin := _smooth_damp_child_global_xform.origin.lerp(target_xform.origin, position_t)
			var result_rotation := lerp_angle(_smooth_damp_child_global_xform.get_rotation(), target_xform.get_rotation(), rotation_t)
			var result_scale := _smooth_damp_child_global_xform.get_scale().lerp(target_xform.get_scale(), rotation_t)
			
			_smooth_damp_child_global_xform = Transform2D(result_rotation, result_scale, 0.0, result_origin)
			child.global_transform = _smooth_damp_child_global_xform
		MotionMode.PHYSICS_INTERPOLATION:
			child.global_transform = _physics_interpolation_previous_xform.interpolate_with(_physics_interpolation_current_xform, Engine.get_physics_interpolation_fraction())

func _validate_property(property: Dictionary) -> void:
	if (property.name as String).begins_with("smoothing") and motion_mode != MotionMode.SMOOTH_DAMP:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _get_configuration_warnings():
	var result := PackedStringArray()
	
	if get_child_count() != 1:
		result.append("Must have exactly 1 child.")
	
	if get_child_count() != 0 and not get_child(0) is Node2D:
		result.append("Child must be a Node2D.")
	
	if motion_mode == MotionMode.PHYSICS_INTERPOLATION and process_func == ProcessFunc.PHYSICS:
		result.append("Using PHYSICS_INTERPOLATION in the PHYSICS process_func won't have any effect. Use FRAME process_func instead.")
	
	return result

## Immediately teleports the child node to its target transform.
func teleport() -> void:
	_physics_interpolation_current_xform = global_transform * _offset_transform
	_physics_interpolation_previous_xform = _physics_interpolation_current_xform
	_smooth_damp_child_global_xform = _physics_interpolation_current_xform
	
	if get_child_count() != 1:
		return
	
	var child: Node2D = get_child(0) as Node2D
	
	if not child:
		return
	
	child.global_transform = _physics_interpolation_current_xform
