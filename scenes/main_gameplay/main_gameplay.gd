extends Node2D

@onready var camera_shake: CameraShake = $Camera2D/CameraShake

var lose_scene = preload("res://scenes/lose_screen/lose_screen.tscn")

func _on_bouncing_character_body_2d_bounce(collision: KinematicCollision2D) -> void:
	#camera_shake.apply_impulse(Vector2.from_angle(randf_range(0, TAU)) * 2000)
	camera_shake.rumble(50, 0.25)

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Building").filter(func(x): return x.team == Enums.Team.BLUE):
		SceneGirl.change_scene(lose_scene)
