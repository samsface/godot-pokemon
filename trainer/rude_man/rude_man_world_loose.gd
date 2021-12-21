extends Game

func _ready():
	var trainer = get_parent()
	yield(info_box.set_text_for_confirm("Are you happy?"), "done")
	yield(info_box.set_text_for_confirm("We're all crying even more now!"), "done")

	#trainer.monitoring = false
	player.pause_controls = false
	info_box.clear_text()
	info_box.visible = false

	done_()
