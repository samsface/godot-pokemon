extends Node
class_name Game

signal done

var info_box
var player
var tween

func floor_vec2(vector:Vector2) -> Vector2:
	return Vector2(floor(vector.x / 16.0) * 16.0, floor(vector.y / 16.0) * 16.0)

func get_player() -> Node:
	return find_parent("level").find_node("player")

func done_() -> void:
	emit_signal("done")
	queue_free()
