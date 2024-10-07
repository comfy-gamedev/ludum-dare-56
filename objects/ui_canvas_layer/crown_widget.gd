@tool
extends AnimatedSprite2D

@export var active: bool = false :set=set_active

func set_active(nv: bool):
	active = nv
	
	if not active:
		play("inactive")
		return
	
	play("flash")
	$FlashDelay.start(randf_range(5.0,10.0))

func _on_flash_delay_timeout():
	if not active:
		return
	play("flash")
	$FlashDelay.start(randf_range(5.0,10.0))
