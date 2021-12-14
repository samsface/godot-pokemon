extends Tween
class_name TweenEx

signal done

func _ready() -> void:
	set_process_unhandled_input(false)

func block() -> Tween:
	connect("tween_all_completed", self, "_on_tween_all_completed", [], CONNECT_DEFERRED | CONNECT_ONESHOT | CONNECT_REFERENCE_COUNTED)
	start()
	call_deferred("set_process_unhandled_input", true)
	return self

func wait(time:float) -> Tween:
	interpolate_method(self, "nop", 0, 0, time)
	block()
	return self

func step_property(object, property, from, to, delay := 0.0) -> void:
	interpolate_property(object, property, from, to, 0, 0, 0, delay)

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		seek(get_runtime())
		get_tree().set_input_as_handled()

func _on_tween_all_completed() -> void:
	emit_signal("done")
	set_process_unhandled_input(false)

func nop(f) -> void:
	pass
