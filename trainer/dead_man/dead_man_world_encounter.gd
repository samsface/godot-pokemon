extends Game

func _ready():
	info_box.visible = true
	yield(info_box.set_text_for_confirm("You climb on the church's electric organ."), "done")
	yield(info_box.set_text_for_confirm("You start to play chopsticks badly."), "done")
	
	var trainer = get_parent()
	trainer.get_node("spot").visible = true
	trainer.get_node("spot_audio").play()
	
	yield(info_box.set_text_for_confirm("NO!"), "done")
	trainer.get_node("spot").visible = false
	yield(info_box.set_text_for_confirm("I just talked to god."), "done")
	yield(info_box.set_text_for_confirm("He agreed you're terrible."), "done")
	yield(info_box.set_text_for_confirm("And reaniamted me to teach you a lesson!"), "done")

	done_()
