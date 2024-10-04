extends Control

var labels_by_prop: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for p in Globals.get_property_list():
		if p.name == "_overlay":
			continue
		if p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var l := Label.new()
			$PanelContainer/Rows.add_child(l)
			labels_by_prop[p.name] = l
	_on_visibility_changed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for k in labels_by_prop:
		labels_by_prop[k].text = "%s: %s" % [k, Globals[k]]


func _on_visibility_changed() -> void:
	if visible:
		process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
