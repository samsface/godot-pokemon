extends Game

func _ready():
	var trainer = get_parent()
	yield(info_box.set_text_for_confirm("No! Don't steal my Wizard Hat!"), "done")
	yield(info_box.set_text_for_confirm("... please... *sobs"), "done")
	yield(info_box.set_text_for_confirm("... please... *sobs"), "done")
	yield(info_box.set_text_for_confirm("... please don't take my Wizard Hat."), "done")
	info_box.visible = false
	yield(tween.wait(5.0), "done")
	info_box.visible = true
	
	#$success.play()
	#trainer.get_node("hat").visible = false
	yield(info_box.set_text_for_confirm("You took the Wizard Hat!"), "done")

	trainer.monitoring = false
	player.pause_controls = false
	info_box.clear_text()
	info_box.visible = false
	
	done_()
