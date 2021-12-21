extends Game

func _on_trigger() -> void:
	player.pause_controls = true
	info_box.visible = true
	yield(info_box.set_text_for_confirm("You want to fight the dead man. But he is dead."), "done");
	yield(info_box.set_text_for_confirm("You settle with chewing his femur."), "done");
	yield(info_box.set_text_for_confirm("You let your HATeMON try some dead man."), "done");
	yield(tween.wait(0.2), "done")
	info_box.success.play()
	yield(info_box.set_text_for_confirm("All HATeMON HP restored!"), "done");
	for p in player.trainer.pokemon:
		p.hp = p.max_hp

	yield(info_box.set_text_for_confirm("You notice a piano to your south."), "done");
	yield(info_box.set_text_for_confirm("You've always wanted to learn."), "done");
	info_box.visible = false
	player.pause_controls = false
	
	FlagDB.flags["dead_man_chewed"] = true
