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

func _on_encounter_cry_baby(trainer) -> void:
	$player.pause_controls = true
	
	trainer.get_node("spot").visible = true
	trainer.get_node("spot_audio").play()
	
	var move_to = floor_vec2($player.position) + $player.position.direction_to(trainer.position) * 20.0
	tween_.interpolate_property(trainer, "position", null, move_to, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.0)
	yield(tween_.block(), "done")
	trainer.get_node("spot").visible = false
	info_box_.visible = true
	
	yield(info_box_.set_text_for_confirm("Aww, someone put a HATeMON on your head."), "done")
	yield(info_box_.set_text_for_confirm("Be careful little pug..."), "done")
	yield(info_box_.set_text_for_confirm("...while HATeMON are our friends..."), "done")
	yield(info_box_.set_text_for_confirm("...they can be dangerous if put to bad use."), "done")
	yield(info_box_.set_text_for_confirm("Look at me... talking to a dog."), "done")
	yield(info_box_.set_text_for_confirm("I guess this funeral has me going crazy in greif."), "done")
	yield(info_box_.set_text_for_confirm("Wait?? What did you just say??"), "done")
	yield(info_box_.set_text_for_confirm("You can speak English little dog?"), "done")
	yield(info_box_.set_text_for_confirm("Amazing! Who taught you?"), "done")
	yield(info_box_.set_text_for_confirm("Now don't be rude; I was just asking..."), "done")
	yield(info_box_.set_text_for_confirm("What?? How dare you??"), "done")
	yield(info_box_.set_text_for_confirm("Please leave! This is a funeral!"), "done")

	yield(battle_transition_(), "done")
	$music.play()

	var battle = preload("res://battle/battle.tscn").instance()
	battle.enemy = trainer.trainer
	$c.add_child(battle)
	$info_box.clear_text()
	yield(battle, "done")
	$music.stop()
	battle.queue_free()

	
func _on_encounter_spikey(trainer) -> void:
	$player.pause_controls = true
	
	trainer.get_node("spot").visible = true
	trainer.get_node("spot_audio").play()
	
	var move_to = floor_vec2($player.position) + $player.position.direction_to(trainer.position) * 16.0
	tween_.interpolate_property(trainer, "position", null, move_to, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.0)
	yield(tween_.block(), "done")
	trainer.get_node("spot").visible = false
	info_box_.visible = true
	yield(info_box_.set_text_for_confirm("Please everyone is so sad. Just leave."), "done")
	tween_.wait(0.1)

	yield(battle_transition_(), "done")
	$music.play()

	var battle = preload("res://battle/battle.tscn").instance()
	battle.enemy = trainer.trainer
	$c.add_child(battle)
	$info_box.clear_text()
	yield(battle, "done")
	$music.stop()
	battle.queue_free()
	yield(info_box_.set_text_for_confirm("No! Don't steal my Wizard Hat!"), "done")
	yield(info_box_.set_text_for_confirm("I can't loose both my son AND my hat!"), "done")
	yield(info_box_.set_text_for_confirm("... please... *sobs."), "done")
	yield(info_box_.set_text_for_confirm("... please... *sobs."), "done")
	yield(info_box_.set_text_for_confirm("... please... *sobs."), "done")
	$info_box.visible = false
	yield(tween_.wait(5.0), "done")
	$info_box.visible = true
	
	$success.play()
	trainer.get_node("hat").visible = false 
	yield(info_box_.set_text_for_confirm("You stole the Wizard Hat!"), "done")

	trainer.monitoring = false
	$player.pause_controls = false
	$info_box.clear_text()
	$info_box.visible = false
	
