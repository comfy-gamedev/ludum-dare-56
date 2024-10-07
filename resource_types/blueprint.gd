class_name Blueprint
extends Resource

@export var name: String = "Unnamed"
@export_multiline var description: String = "Indescribable."
@export var size: Vector2i = Vector2i(1, 1)
@export var spawned_scene: PackedScene
@export var hotbar_scene: PackedScene
@export var cost: int = 2
