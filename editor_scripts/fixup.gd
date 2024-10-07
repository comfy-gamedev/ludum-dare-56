@tool
extends EditorScript

var BPS = [
"res://blueprints/autocannon.tres",
"res://blueprints/barricade.tres",
"res://blueprints/buffer.tres",
"res://blueprints/extender.tres",
"res://blueprints/farm.tres",
"res://blueprints/goblin_cage.tres",
"res://blueprints/goblin_spawner.tres",
"res://blueprints/laser_turret.tres",
"res://blueprints/mage_spawner.tres",
"res://blueprints/rat_spawner.tres",
"res://blueprints/repairer.tres",
"res://blueprints/rock_turret.tres",
"res://blueprints/shotgun_turret.tres",
"res://blueprints/snake_spawner.tres",
"res://blueprints/sniper_turret.tres",
"res://blueprints/tesla_turret.tres",
]

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	for bp:String in BPS:
		var bpp = load(bp)
		bpp.name = bp.get_file().trim_suffix(".tres").to_pascal_case()
		ResourceSaver.save(bpp)
