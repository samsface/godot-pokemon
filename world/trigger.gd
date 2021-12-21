extends Area2D
class_name Trigger

signal trigger

export(bool) var passive
export(Array, String) var flag

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")

func test_() -> bool:
	for expression in flag:
		var e := Expression.new()
		e.parse(expression)
		if not e.execute([], FlagDB):
			return false
	return true

func _on_area_entered(area):
	if passive:
		return
	
	if not test_():
		return

	set_deferred("monitoring", false)
	emit_signal("trigger")

func _input(event) -> void:
	if not Input.is_action_just_pressed("ui_accept"):
		return
	
	if not monitoring:
		return
	
	if not test_():
		return

	var player = find_parent("level").find_node("player")
	if overlaps_area(player):
		set_deferred("monitoring", false)
		emit_signal("trigger")
