extends Resource
class_name PokemonModel

signal name_changed 
signal level_changed
signal hp_changed
signal max_hp_changed
signal xp_changed

export(String) var name:String setget set_name
export(int) var level:int  setget set_level
export(int) var hp:int setget set_hp
export(int) var max_hp:int setget set_max_hp
export(int) var xp:int setget set_xp
export(int) var attack:int = 1
export(int) var defense:int = 1
export(int) var speed:int = 1
export(Array, Resource) var moves
export(PackedScene) var battle_graphics

func prop_change_(property:String, from, to) -> void:
	emit_signal(property + "_changed", from, to)
	emit_signal("changed")

func set_name(value:String) -> void:
	var old := name
	name = value
	prop_change_("name", old, value)

func set_level(value:int) -> void:
	var old := level
	level = value
	prop_change_("level", old, value)

func set_hp(value:int) -> void:
	var old := hp
	hp = max(0, value)
	prop_change_("hp", old, value)

func set_max_hp(value:int) -> void:
	var old := max_hp
	max_hp = value
	prop_change_("max_hp", old, value)

func set_xp(value:int) -> void:
	var old := xp
	xp = value
	prop_change_("xp", old, value)

func is_dead() -> bool:
	return hp <= 0

