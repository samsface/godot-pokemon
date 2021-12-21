extends Game
class_name GenericEncounter

var text:TextModel

func _ready() -> void:
	player.pause_controls = true
	
	var trainer = get_parent()
	
	trainer.get_node("spot").visible = true
	trainer.get_node("spot_audio").play()
	
	var move_to = floor_vec2(player.position) + player.position.direction_to(trainer.position) * 20.0
	tween.interpolate_property(trainer, "position", null, move_to, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.0)
	yield(tween.block(), "done")
	trainer.get_node("spot").visible = false
	info_box.visible = true

	for l in text.text.split("\n"):
		if l.empty():
			continue
		yield(info_box.set_text_for_confirm(l), "done")

	done_() 
