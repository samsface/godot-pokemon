extends Node2D

onready var tween_:TweenEx = $tween
onready var info_box_ = $info_box

func floor_vec2(vector:Vector2) -> Vector2:
	return Vector2(floor(vector.x / 16.0) * 16.0, floor(vector.y / 16.0) * 16.0)

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("trainer"):
		node.connect("encounter", self, "_on_encounter", [node])

	$exit.monitoring = false

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

	s.player = $player
	s.info_box = info_box_
	s.tween = tween_
	parent.add_child(s)
	return s

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

func _on_dead_man_chew_trigger():
	$player.pause_controls = true
	info_box_.visible = true
	yield(info_box_.set_text_for_confirm("You want to fight the dead man. But he is dead."), "done");
	yield(info_box_.set_text_for_confirm("You settle with chewing his femur."), "done");
	yield(info_box_.set_text_for_confirm("You let your HATeMON try some dead man."), "done");
	yield($tween.wait(0.2), "done")
	$success.play()
	yield(info_box_.set_text_for_confirm("All HATeMON HP restored!"), "done");
	for p in $player.trainer.pokemon:
		p.hp = p.max_hp

	yield(info_box_.set_text_for_confirm("You notice a piano to your south."), "done");
	yield(info_box_.set_text_for_confirm("You've always wanted to learn."), "done");
	info_box_.visible = false
	$player.pause_controls = false

func _on_exit_trigger():
	$player.pause_controls = true
	info_box_.visible = true
	yield(info_box_.set_text_for_confirm("You exit the church..."), "done");
	yield(info_box_.set_text_for_confirm("...annoyed nobody pet you."), "done");
	yield($tween.wait(0.2), "done")
	get_tree().change_scene("res://end.tscn")

func _on_dead_man_beat():
	$exit.monitoring = true
