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
	$faint.play()
	tween_.interpolate_property(self, "position:y", null, 200, 0.5, Tween.TRANS_QUAD)
	return tween_.block()

func enter():
	$enter.pitch_scale = 1.0 + rand_range(-0.3, 0.9)
	$enter.play()
	tween_.interpolate_property(self, "scale", Vector2(), scale, 0.5, Tween.TRANS_QUAD)
	scale = Vector2()
	return tween_.block()

func withdraw():
	tween_.interpolate_property(self, "scale", null, Vector2(), 0.5, Tween.TRANS_QUAD)
	return tween_.block()
