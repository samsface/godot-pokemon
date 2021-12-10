extends Node2D

signal animate_hp_done

export(String) var text setget set_text
export(int) var level setget set_level
export(int) var hp setget set_hp
export(int) var max_hp = 1 setget set_max_hp

func set_text(value:String) -> void:
	text = value
	$name.text = value.to_upper()
	
func set_level(value:int) -> void:
	level = value
	$level.text = str(value)

func set_hp(value) -> void:
	hp = value
	$hp.text = str(int(hp)) + "/ " + str(max_hp)
	$hp_bar/line.points[1].x = (float(hp) / float(max_hp)) * 48.0

func set_max_hp(value) -> void:
	max_hp = value
	set_hp(hp)

func animate_hp(value) -> Node:
	$tween.interpolate_property(self, "hp", null, value, 1.0)
	$tween.start()
	$tween.connect("tween_all_completed", self, "emit_signal", ["animate_hp_done"], CONNECT_ONESHOT)

	return self
