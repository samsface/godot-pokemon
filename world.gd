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

func _on_encounter(trainer) -> void:
	$player.pause_controls = true
	
	var move_to = floor_vec2($player.position) + $player.position.direction_to(trainer.position) * 16.0
	tween_.interpolate_property(trainer, "position", null, move_to, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.0)
	yield(tween_.block(), "done")
	info_box_.visible = true
	yield(info_box_.set_text_for_confirm("This is a funeral little dog."), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("A sad time to reflect."), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("Oh wow little dog? You can speak English?"), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("Who taught you?"), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("Now don't be rude; I was just asking..."), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("What?? How dare you??"), "done")
	tween_.wait(0.1)
	yield(info_box_.set_text_for_confirm("Please leave! This is a funeral!"), "done")
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
	$info_box.visible = false
	yield(tween_.wait(5.0), "done")
	$info_box.visible = true
	
	$success.play()
	yield(info_box_.set_text_for_confirm("You collected Wizard Hat!"), "done")

	trainer.monitoring = false
	$player.pause_controls = false
	$info_box.clear_text()
	$info_box.visible = false
	
