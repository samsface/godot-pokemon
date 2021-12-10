tool
extends HBoxContainer

export(bool)   var capitalize setget set_capitalize
export(String) var text setget set_text
export(bool)   var selected setget set_selected
export(bool)   var off

func set_text(value) -> void:
	text = str(value)
	if has_node("label"):
		$label.text = text.to_upper() if capitalize else text

func set_capitalize(value:bool) -> void:
	capitalize = value

func set_selected(value:bool) -> void:
	selected = value
	$pointer.modulate.a = 1.0 if selected else 0.0
