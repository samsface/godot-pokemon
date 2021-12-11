extends Position2D

onready var stats = find_node("stats")
onready var trainer = find_node("trainer")
var pokemon setget set_pokemon, get_pokemon

func set_pokemon(value):
	if get_pokemon():
		get_pokemon().free()
	find_node("pokemon").add_child(value.instance())

func get_pokemon() -> Node:
	return find_node("pokemon").get_child(0)


