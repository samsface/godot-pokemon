extends Menu

onready var info_ = $info

export(Array, Resource) var pokemon

func _ready():
	info_.animate_text("Bring out which pokemon?")
	
	for p in pokemon:
		var menu_item = preload("res://widgets/menu_button.tscn").instance()
		var contents = preload("res://widgets/pokemon_info_mini.tscn").instance()
		menu_item.add_child(contents)
		add_menu_item(menu_item)
