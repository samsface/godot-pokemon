extends Menu

func _ready() -> void:
	set_process_input(false)
	connect("music", self, "_on_toggle_music")
	connect("quit", get_tree(), "quit")

func _on_toggle_music() -> void:
	var i := AudioServer.get_bus_index("music")
	AudioServer.set_bus_mute(i, not AudioServer.is_bus_mute(i))
	
	find_node("music").text = "MUSIC: " + ("OFF" if AudioServer.is_bus_mute(i) else "ON")

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause_()
		get_tree().set_input_as_handled()

func toggle_pause_() -> void:
	get_tree().paused = not get_tree().paused
	visible = not visible
	set_process_input(visible)
	select_(0, true)
