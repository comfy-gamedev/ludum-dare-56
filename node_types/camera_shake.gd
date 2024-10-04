@tool
class_name CameraShake
extends Node
## Used as a child node for a [class Camera2D] or [class Camera3D], provides two methods of camera shake.
##
## Implemented as a spring simulation with added noise.
##
## When used as a child of [class Camera2D], applies shake to [member Camera2D.offset].
##
## When used as a child of [class Camera3D],
## applies shake to [member Camera3D.h_offset] and [member Camera3D.v_offset].
##
## Spring simulation uses h4tt3n's technique:
## https://gamedev.net/tutorials/programming/math-and-physics/towards-a-simpler-stiffer-and-more-stable-spring-r3227/
##
## Spring simulation behavior is influenced by [member Engine.physics_ticks_per_second].

## Spring coefficient. Values 0.25 and lower are recommended.
@export_range(0.0, 1.0) var shake_spring_coef: float = 0.1

## Spring damping coefficient. Values 1.0 and lower are recommended.
@export_range(0.0, 2.0) var shake_spring_damp: float = 0.3

## The maximum allowed offset for the spring simulation. Note that this does not affect rumble.
@export var max_offset: Vector2 = Vector2(50, 50):
	set(v): max_offset = v.clamp(Vector2.ZERO, Vector2.INF)

## The maximum allowed velocity for the spring simulation. Note that this does not affect rumble.
@export var max_velocity: Vector2 = Vector2(2000, 2000):
	set(v): max_velocity = v.clamp(Vector2.ZERO, Vector2.INF)

## How quickly the rumble moves through the noise.
@export var rumble_speed: float = 10.0

## The nosie to use for rumble.
@export var rumble_noise: Noise = preload("res://node_types/camera_shake/default_camera_rumble_noise.tres"):
	set(v): rumble_noise = v; update_configuration_warnings()

var _spring_velocity: Vector2
var _spring_offset: Vector2
var _previous_spring_offset: Vector2

var _rumble_intensity: float
var _rumble_tween: Tween
var _rumble_time: float

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)

func _process(delta: float) -> void:
	var spring_offset := _previous_spring_offset.lerp(_spring_offset, Engine.get_physics_interpolation_fraction())
	
	var rumble_offset := Vector2.ZERO
	
	if rumble_noise:
		_rumble_time += delta * rumble_speed
		rumble_offset = _rumble_intensity * Vector2(
			rumble_noise.get_noise_1d(_rumble_time),
			rumble_noise.get_noise_1d(_rumble_time + 54321.1))
	
	var offset := spring_offset + rumble_offset
	
	var camera = get_parent()
	
	if camera is Camera2D:
		camera.offset = offset
	elif camera is Camera3D:
		camera.h_offset = offset.x
		camera.v_offset = offset.y

func _physics_process(delta: float) -> void:
	_previous_spring_offset = _spring_offset
	
	var spring_impulse := - shake_spring_coef * _spring_offset / delta - shake_spring_damp * _spring_velocity
	_spring_velocity += spring_impulse
	_spring_offset += _spring_velocity * delta
	
	if max_offset:
		if abs(_spring_offset.x) > max_offset.x and sign(_spring_offset.x) == sign(_spring_velocity.x):
			_spring_velocity.x = 0.0
		
		if abs(_spring_offset.y) > max_offset.y and sign(_spring_offset.y) == sign(_spring_velocity.y):
			_spring_velocity.y = 0.0
		
		_spring_offset = _spring_offset.clamp(-max_offset, max_offset)

func _get_configuration_warnings() -> PackedStringArray:
	var result := PackedStringArray()
	if not (get_parent() is Camera2D or get_parent() is Camera3D):
		result.append("Parent must be a Camera2D or Camera3D")
	if not rumble_noise:
		result.append("rumble_noise is required for rumble()")
	return result

## Applies a velocity impulse to the spring simulation.
##
## [param impulse]: velocity impulse.
func apply_impulse(impulse: Vector2) -> void:
	_spring_velocity += impulse
	if max_velocity:
		_spring_velocity = _spring_velocity.clamp(-max_velocity, max_velocity)

## Starts a rumble which decays over time. Replaces any existing rumble.
##
## [param intensity]: initial displacement.
## [param duration]: decay duration in seconds.
func rumble(intensity: float, duration: float) -> void:
	if not rumble_noise:
		push_error("CameraShake: rumble_noise is null, rumble() will have no effect.")
	
	if _rumble_tween:
		_rumble_tween.kill()
	
	_rumble_intensity = intensity
	_rumble_tween = create_tween()
	_rumble_tween.tween_property(self, "_rumble_intensity", 0.0, duration)
