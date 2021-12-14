extends Resource
class_name TrainerModel

export(String) var name
export(Array, Resource) var pokemon
export(Array, Resource) var items
export(bool) var is_player
export(Resource) var world_encounter
export(Resource) var battle_begin
export(Resource) var battle_loose
export(Resource) var world_loose
export(PackedScene) var battle_graphic
export(PackedScene) var world_graphic

var active_pokemon

func is_dead() -> bool:
	for p in pokemon:
		if p.hp > 0:
			return false
	return true
