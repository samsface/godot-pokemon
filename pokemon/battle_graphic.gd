extends Node2D

var tween_:TweenEx
var tween__:Tween

func _ready()-> void:
	tween_ = TweenEx.new()
	tween__ = Tween.new()
	add_child(tween_)
	add_child(tween__)
	
	tween__.repeat = true
	$front.rotation_degrees = 5
	tween__.interpolate_property($front, "rotation_degrees", 5,  -5, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.0)
	tween__.interpolate_property($front, "rotation_degrees", -5, 5, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1.0)
	tween__.start()

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
	
func level_up():
	$level_up.play()

func learn():
	$learn.play()

func enter():
	$enter.pitch_scale = 1.0 + rand_range(-0.3, 0.9)
	$enter.play()
	tween_.interpolate_property(self, "scale", Vector2(), scale, 0.5, Tween.TRANS_QUAD)
	scale = Vector2()
	return tween_.block()

func withdraw():
	tween_.interpolate_property(self, "scale", null, Vector2(), 0.5, Tween.TRANS_QUAD)
	return tween_.block()
