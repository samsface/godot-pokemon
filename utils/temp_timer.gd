extends Reference
class_name TempTimer

class TempTimer_ extends Timer:
	var callback_:FuncRef
	
	func _on_timeout(arg) -> void:
		if callback_.is_valid():
			callback_.call_func(arg)
		queue_free()
		
class FrameTimer_ extends Node:
	signal timeout

	var frames := 1

	func _ready() -> void:
		get_tree().connect("idle_frame", self, "_on_timeout")

	func _on_timeout() -> void:
		frames -= 1
		if frames == 0:
			emit_signal("timeout")
			queue_free()

static func timeout(node:Node, callback:String, time:float, arg = null):
	var t := TempTimer_.new()
	t.callback_ = funcref(node, callback)
	t.connect("timeout", t, "_on_timeout", [arg])
	t.wait_time = time + 0.00001
	t.autostart = true
	node.add_child(t)
	
	return t
	
static func timeouts(node:Node, time:float):
	var t := TempTimer_.new()
	t.autostart = true
	t.wait_time = time
	node.add_child(t)

	return t
	
static func idle_frame(node:Node, frames:int = 1):
	var t   := FrameTimer_.new()
	t.frames = frames
	node.add_child(t)
	
	return t
