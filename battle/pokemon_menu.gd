extends Menu

onready var info_ = $info

export(Array, Resource) var pokemon setget set_pokemon

func set_pokemon(value) -> void:
	pokemon = value
	clear()
	invalidate_()

func invalidate_() -> void:
	for p in pokemon:
		var menu_item = preload("res://widgets/menu_button.tscn").instance()
		var contents = preload("res://widgets/pokemon_info_mini.tscn").instance()
		menu_item.add_child(contents)
		add_menu_item(menu_item)

func _ready():
	info_.animate_text("Bring out which pokemon?")
	invalidate_()
