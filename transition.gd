extends Node2D

signal done

func start():
	var bitmap := BitMap.new()
	bitmap.create(Vector2(10, 9))
	
	var head := Vector2(10, 0)
	var dir := Vector2.LEFT
	
	while true:
		if bitmap.get_bit(head):
			break

		yield(get_tree().create_timer(0.01), "timeout")
		bitmap.set_bit(head, true)
		
		var s = $square.duplicate()
		add_child(s)
		s.rect_position = head * 16.0

		var next_head = head + dir
		if not Rect2(Vector2(), Vector2(10, 9)).has_point(next_head) or bitmap.get_bit(next_head):
			dir = dir.rotated(deg2rad(-90))
			dir.x = round(dir.x)
			dir.y = round(dir.y)

		head += dir
	
	emit_signal("done")

