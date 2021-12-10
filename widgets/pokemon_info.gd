extends Node

signal animate_hp_done

export(String) var text setget set_text
export(int) var level setget set_level
export(int) var hp setget set_hp
export(int) var max_hp setget set_max_hp

func set_from_pokemon(pokemon) -> void:
	set_text(pokemon.name)
	set_level(pokemon.level)
	set_max_hp(pokemon.max_hp)
	set_hp(pokemon.hp)

func set_text(value:String) -> void:
	text = value
	$name.text = value.to_upper()
	
func set_level(value:int) -> void:
	level = value
	$level.text = str(value)

func set_hp(value) -> void:
	if max_hp == 1:
		pass
	hp = value
	$hp_bar/hp.text = str(int(hp)) + "/ " + str(max_hp)
	$hp_bar/bar/line.points[1].x = (float(hp) / float(max_hp)) * 48.0

func set_max_hp(value) -> void:
	max_hp = value
	set_hp(hp)

func animate_hp(value) -> Node:
	$tween.interpolate_property(self, "hp", null, value, 1.0)
	$tween.block()
	$tween.connect("tween_all_completed", self, "emit_signal", ["animate_hp_done"], CONNECT_ONESHOT)

	return self
