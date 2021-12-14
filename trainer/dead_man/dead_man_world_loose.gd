extends Game

func _ready():
	var trainer = get_parent()
	yield(info_box.set_text_for_confirm("Please just leave..."), "done")

	player.pause_controls = false
	info_box.clear_text()
	info_box.visible = false

	done_()
