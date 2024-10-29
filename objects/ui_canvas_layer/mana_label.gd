extends Control

@onready var incoming_label: Label = $IncomingNinePatchRect/IncomingLabel
@onready var amount_label: Label = $NinePatchRect/AmountLabel

@onready var incoming_nine_patch_rect: NinePatchRect = $IncomingNinePatchRect

var amount: int: set = set_amount
var temp_amount: int: set = set_temp_amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.blue_mana_changed.connect(_on_mana_changed)
	Globals.blue_temp_income_changed.connect(_on_temp_changed)
	Globals.phase_changed.connect(_on_phase_changed)

func set_amount(v: int):
	amount = v
	amount_label.text = str(v)

func set_temp_amount(v: int):
	temp_amount = v
	incoming_label.text = "+" + str(temp_amount)

func _on_mana_changed() -> void:
	create_tween().tween_property(self, "amount", Globals.blue_mana, 0.25)

func _on_temp_changed() -> void:
	create_tween().tween_property(self, "temp_amount", Globals.blue_temp_income, 0.25)

func _on_phase_changed() -> void:
	match Globals.phase:
		Enums.Phase.FIGHT:
			create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(incoming_nine_patch_rect, "position:x", 26, 0.5)
		_:
			create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK).tween_property(incoming_nine_patch_rect, "position:x", -4, 0.5)
