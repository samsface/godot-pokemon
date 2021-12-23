extends Node2D

onready var tween_:TweenEx = $tween
onready var info_box_ = $info_box

func floor_vec2(vector:Vector2) -> Vector2:
	return Vector2(floor(vector.x / 16.0) * 16.0, floor(vector.y / 16.0) * 16.0)

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("trainer"):
		node.connect("encounter", self, "_on_encounter", [node])

func battle_transition_() -> Node:
	var transition = $transition.create_instance()
	transition.start()
	return transition

func play_script_(parent, script):
	var s
	if script is Script:
		s = script.new()
	elif script is TextModel:
		s = GenericEncounter.new()
		s.text = script

	parent.add_child(s)
	return s

var db_ := {}

func _on_encounter(trainer) -> void:
	yield(play_script_(trainer, trainer.trainer.world_encounter), "done")

	$music.play()
	yield(battle_transition_(), "done")

	var battle = preload("res://battle/battle.tscn").instance()
	battle.enemy = trainer.trainer
	$c.add_child(battle)
	yield(battle, "done")
	$music.stop()
	battle.queue_free()
	
	yield(play_script_(trainer, trainer.trainer.world_loose), "done")
	
	trainer.emit_signal("beat")
	FlagDB.flags[trainer.trainer.id + "_beat"] = true
