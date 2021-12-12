extends Node2D

signal done

export(Vector2) var target_position

var delta_sum_ := 0.0

func _ready():
	position = target_position
	$tween.interpolate_property(Cam, "offset", null, Vector2( 4, 0), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$tween.interpolate_property(Cam, "offset", null, Vector2(-4, 0), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0.1)
	$tween.interpolate_property(Cam, "offset", null, Vector2( 0, 0), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT, 0.2)
	$tween.start()

func _process(delta) -> void:
	delta_sum_ += delta

	#$circle.visible = sin(delta_sum_ * 20.0) > 0.0
	$c/invert.value = sin(delta_sum_ * 20.0) > 0.5

	if delta_sum_ > 2.0:
		emit_signal("done")

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().set_input_as_handled()
		emit_signal("done")
