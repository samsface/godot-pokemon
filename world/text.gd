extends Game

export(String, MULTILINE) var text

func _on_trigger():
	player.pause_controls = true
	info_box.visible = true

	for l in text.split("\n"):
		if l.empty():
			continue
		yield(info_box.set_text_for_confirm(l), "done")

	player.pause_controls = false
	info_box.visible = false
