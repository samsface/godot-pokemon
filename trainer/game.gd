extends Node
class_name Game

signal done

var info_box
var player
var tween
var level

func _ready() -> void:
	level = find_parent("level")
	info_box = level.get_node("info_box")
	tween = level.get_node("tween")
	player = level.find_node("player")

	for node in get_children():
		if node is Trigger:
			node.connect("trigger", self, "_on_trigger")

func _on_trigger() -> void:
	pass

func floor_vec2(vector:Vector2) -> Vector2:
	return Vector2(floor(vector.x / 16.0) * 16.0, floor(vector.y / 16.0) * 16.0)

func get_player() -> Node:
	return find_parent("level").find_node("player")

func done_() -> void:
	emit_signal("done")
	queue_free()
