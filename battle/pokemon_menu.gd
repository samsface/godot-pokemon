extends Menu

onready var info = $info

export(Array, Resource) var pokemon setget set_pokemon

func set_pokemon(value) -> void:
	pokemon = value
	invalidate_()

func invalidate_() -> void:
	clear()

	for p in pokemon:
		var menu_item = preload("res://widgets/menu_button.tscn").instance()
		var mini_pokemon_info = preload("res://widgets/pokemon_info_mini.tscn").instance()
		mini_pokemon_info.set_from_pokemon(p)
		menu_item.add_child(mini_pokemon_info)
		menu_item.off = p.hp <= 0
		add_menu_item(menu_item)

func _on_visibility_changed():
	if visible:
		invalidate_()
