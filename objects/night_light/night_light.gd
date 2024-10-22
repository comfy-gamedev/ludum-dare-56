extends Node2D

@export var radius: float = 32.0
@export var texture: Texture2D

var flicker: float = 1.0

var _remote_transform: RemoteTransform2D

@onready var timer: Timer = $Timer

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	timer.start(randf_range(0.1, 0.2))

func _enter_tree() -> void:
	assert(_remote_transform == null)
	_remote_transform = RemoteTransform2D.new()
	_remote_transform.name = "NightLightRemoteTransform2D"
	_remote_transform.position = get_parent().get_center_offset()
	get_parent().add_child(_remote_transform)
	_remote_transform.remote_path = self.get_path()

func _exit_tree() -> void:
	if is_instance_valid(_remote_transform):
		_remote_transform.queue_free()
		_remote_transform = null

func _draw() -> void:
	var r = radius * flicker
	draw_texture_rect(texture, Rect2(-r, -r, r*2, r*2), false)

func _on_timer_timeout() -> void:
	var f = randf_range(1.0, 1.1)
	flicker = move_toward(flicker, f, 0.05)
	queue_redraw()
	timer.start(randf_range(0.3, 0.4))
