extends PanelContainer

onready var info_text_ = find_node("info_text")
onready var tween_ = find_node("tween")
onready var arrow_ = find_node("arrow")

func set_text(text, post_delay:float = 0.7) -> Tween:
	info_text_.percent_visible = 0
	info_text_.bbcode_text = str(text)
	tween_.interpolate_property(info_text_, "percent_visible", null, 1, 0.5)
	tween_.interpolate_method(tween_, "nop", 0, 0, post_delay, 0, 0, 0.5)
	return tween_.block()

func set_text_for_confirm(text) -> Tween:
	info_text_.percent_visible = 0
	info_text_.bbcode_text = str(text)
	tween_.interpolate_property(info_text_, "percent_visible", null, 1, 0.5)
	tween_.step_property(arrow_, "visible", false, true, 0.5)
	tween_.interpolate_method(tween_, "nop", 0, 0, 999999999, 0, 0, 0.5)
	tween_.connect("tween_all_completed", arrow_, "set_visible", [false], CONNECT_ONESHOT | CONNECT_REFERENCE_COUNTED)
	tween_.connect("tween_all_completed", $activate, "play", [], CONNECT_ONESHOT | CONNECT_REFERENCE_COUNTED)
	return tween_.block()

func clear_text() -> void:
	arrow_.visible = false
	info_text_.bbcode_text = ""
