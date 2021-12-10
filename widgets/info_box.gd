extends PanelContainer

signal animate_text_done

onready var info_text_ = find_node("info_text")
onready var tween_ = find_node("tween")

func animate_text(text) -> Node:
	info_text_.percent_visible = 0
	info_text_.bbcode_text = str(text)
	tween_.interpolate_property(info_text_, "percent_visible", null, 1, 0.5)
	tween_.start()
	tween_.connect("tween_all_completed", self, "emit_signal", ["animate_text_done"])
	return self
