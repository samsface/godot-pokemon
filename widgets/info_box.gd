extends PanelContainer

signal done

onready var info_text_ = find_node("info_text")
onready var tween_ = find_node("tween")

func set_text(text, post_delay:float = 0.5) -> Node:
	info_text_.percent_visible = 0
	info_text_.bbcode_text = str(text)
	tween_.interpolate_property(info_text_, "percent_visible", null, 1, 0.5)
	tween_.interpolate_method(tween_, "nop", 0, 0, post_delay, 0, 0, 0.5)
	tween_.connect("tween_all_completed", self, "emit_signal", ["done"])
	tween_.block()
	return self

func clear_text() -> void:
	info_text_.bbcode_text = ""
