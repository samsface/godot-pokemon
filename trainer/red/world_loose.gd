extends Game

func _ready():
	var trainer = get_parent()
	yield(info_box.set_text_for_confirm("No! Don't steal my Wizard Hat!"), "done")
	yield(info_box.set_text_for_confirm("It's all I have left of my son!"), "done")
	yield(info_box.set_text_for_confirm("... please... *sobs"), "done")
	yield(info_box.set_text_for_confirm("... please... *sobs"), "done")
	yield(info_box.set_text_for_confirm("... please don't take my Wizard Hat."), "done")
	info_box.visible = false
	yield(tween.wait(5.0), "done")
	info_box.visible = true
	
	info_box.success.play()

	yield(info_box.set_text_for_confirm("You took the Wizard Hat!"), "done")
	player.trainer.pokemon.push_back(trainer.trainer.pokemon[0])
	trainer.trainer.pokemon[0].hp = trainer.trainer.pokemon[0].max_hp

	player.pause_controls = false
	info_box.clear_text()
	info_box.visible = false
	
	done_()
