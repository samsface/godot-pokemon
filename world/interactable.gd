extends Area2D

signal trigger

export(String, MULTILINE) var text
export(bool) var passive

func _on_area_entered(area):
	if not passive:
		set_deferred("monitoring", false)
		emit_signal("trigger")

func _input(event) -> void:
	if not monitoring:
		return

	if Input.is_action_just_pressed("ui_accept"):
		var player = find_parent("level").find_node("player")
		if overlaps_area(player):
			set_deferred("monitoring", false)
			emit_signal("trigger")
