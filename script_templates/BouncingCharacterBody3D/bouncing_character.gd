extends BouncingCharacterBody3D

const SPEED = 5.0

func _ready() -> void:
	velocity = Vector3.RIGHT * SPEED

func _physics_process(delta: float) -> void:
	move_and_bounce()

# Called when move_and_bounce() collides with something.
# Return true to stop further motion processing.
func _on_bounce(collision: KinematicCollision3D) -> bool:
	return false

# Called when colliding with something for any reason.
func _collision(other: PhysicsBody3D) -> void:
	pass
