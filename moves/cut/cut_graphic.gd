extends MoveGraphic

func _play():
	for i in 2:
		$sprite.visible = true
		$sprite.position = attacker_graphics.position
		$sprite.look_at(defender_graphics.position)
		shake_camera_()
		play_audio_($audio)
		tween_.interpolate_property($sprite, "position", attacker_graphics.position, defender_graphics.position, 0.5, Tween.TRANS_QUAD)
		tween_.interpolate_callback($sprite, 0.5, "set_visible", false)
		if has_node("c"):
			tween_.interpolate_property($c/shader, "value", 0.0, 1.0, 0.1, 0, 0, 0.6)
			tween_.interpolate_property($c/shader, "value", 1.0, 0.0, 0.0, 0, 0, 0.8)
		shake_camera_(8.0, 0.5)
		play_audio_($audio_hit, 0.5)
		tween_.interpolate_callback(defender_graphics, 0.5, "set_visible", false)
		tween_.interpolate_callback(defender_graphics, 0.55, "set_visible", true)
		wait_(1.3)
		yield(tween_.block(), "done")

	emit_signal("done")
