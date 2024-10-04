class_name BouncingCharacterBody3D
extends CharacterBody3D
## An extended CharacterBody3D which behaves as a perfectly elastic body which maintains a constant speed.
##
## Good for making 3D pong.

## Emitted each time this body bounces off something.
signal bounce(collision: KinematicCollision3D)

## The maximum number of bounces that can happen per frame.
##
## Needs to be set low enough to prevent excessive processing,
## but if set too low may cause collision issues for fast moving bodies.
@export var max_bounces: int = 16

## Used in a similar manner to [method CharacterBody3D.move_and_slide].
##
## Does not perform any velocity adjustments from moving platforms.
## Maintains a constant speed.
##
## On each bounce, emits [signal bounce].
## If the body's script has an `_on_bounce` method, that method will also be called.
## Also checks both bodies for a `_collide` method and calls that method.
func move_and_bounce() -> void:
	var axis_lock := Vector3(
		0.0 if axis_lock_linear_x else 1.0,
		0.0 if axis_lock_linear_y else 1.0,
		0.0 if axis_lock_linear_z else 1.0)
	
	var delta := get_physics_process_delta_time() if Engine.is_in_physics_frame() else get_process_delta_time()
	var motion := velocity * delta
	var collision := move_and_collide(motion)
	var bounce_count := 0
	
	while collision:
		bounce_count += 1
		var normal := (collision.get_normal() * axis_lock).normalized()
		
		if normal:
			velocity = velocity.bounce(normal)
			motion = collision.get_remainder().bounce(normal)
		else:
			motion = collision.get_remainder()
		
		var stop = false
		
		print("Collision: %s <-> %s" % [name, collision.get_collider().name])
		
		bounce.emit(collision)
		
		if has_method(&"_collision"):
			call(&"_collision", collision.get_collider())
		if collision.get_collider().has_method(&"_collision"):
			collision.get_collider().call(&"_collision", self)
		
		if has_method(&"_on_bounce"):
			stop = call(&"_on_bounce", collision)
		
		if stop:
			break
		
		if bounce_count >= max_bounces:
			break
		
		collision = move_and_collide(motion)
		
