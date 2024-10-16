class_name Enums
extends Node

enum Team {
	BLUE = 0,
	RED = 1,
}

enum BuildingType {
	UNSPECIFIED,
	CORE,
	TURRET,
	FORTIFICATION,
	SPAWNER,
	PRODUCTION,
}

enum BlueprintCategory {
	TURRET,
	FORTIFICATION,
	SPAWNER,
	PRODUCTION,
}

enum Phase {
	STANDBY,
	BUILD,
	FIGHT,
}

enum Upgrades {
	STARTER,
	FORTIFICATIONS,
	BLUEPRINTS,
	ANYTHING,
}

const Palette = {
	BLACK = Color("000000"),
}
