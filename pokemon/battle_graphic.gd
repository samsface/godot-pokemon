extends Node2D

var tween_:TweenEx

func _ready()-> void:
	tween_ = TweenEx.new()
	add_child(tween_)

func show_back():
	$front.visible = false
	$back.visible = true

func show_front():
	$front.visible = true
	$back.visible = false

func faint():
	tween_.interpolate_property(self, "position:y", null, 200, 0.5)
	return tween_.block()

func enter():
	tween_.interpolate_property(self, "scale", Vector2(), scale, 0.5)
	scale = Vector2()
	return tween_.block()

func withdraw():
	tween_.interpolate_property(self, "scale", null, Vector2(), 0.5)
	return tween_.block()
