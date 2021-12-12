extends Position2D

onready var stats = find_node("stats")
onready var trainer = find_node("trainer") setget set_trainer, get_trainer
var pokemon setget set_pokemon, get_pokemon

func set_pokemon(value):
	if get_pokemon():
		get_pokemon().free()
	find_node("pokemon").add_child(value.instance())

func get_pokemon() -> Node:
	return find_node("pokemon").get_child(0)

func set_trainer(value):
	trainer = value

func get_trainer():
	return get_node_or_null("trainer")
