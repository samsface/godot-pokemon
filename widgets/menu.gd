extends Control
class_name Menu

signal activated
signal cancel

export(Array, NodePath) var menu_items

var idx_ := 0
var activate_sound_:AudioStreamPlayer
var select_sound_:AudioStreamPlayer
var cancel_sound_:AudioStreamPlayer
var input_ := false

func add_text_menu_item(text:String) -> void:
	var menu_item := preload("res://widgets/menu_button.tscn").instance()
	menu_item.capitalize = true
	menu_item.text = text
	add_menu_item(menu_item)

func add_menu_item(menu_item) -> void:
	find_node("col_1").add_child(menu_item)
	menu_items.push_back(menu_item.get_path())

	if menu_items.size() == 1:
		select_(0, true)

func clear() -> void:
	for node in menu_items:
		get_node(node).queue_free()

	menu_items.clear()

func _ready() -> void:
	activate_sound_ = AudioStreamPlayer.new()
	activate_sound_.stream = preload("res://sounds/activate.wav")
	add_child(activate_sound_)
	
	select_sound_ = AudioStreamPlayer.new()
	select_sound_.stream = preload("res://sounds/select.wav")
	add_child(select_sound_)
	
	cancel_sound_ = AudioStreamPlayer.new()
	cancel_sound_.stream = preload("res://sounds/cancel.wav")
	add_child(cancel_sound_)

	for path in menu_items:
		add_user_signal(get_node(path).name)

func _input(event):
	input_ = true

	if Input.is_action_just_pressed("ui_up"):
		up_()
	elif Input.is_action_just_pressed("ui_down"):
		down_()
	elif Input.is_action_just_pressed("ui_select"):
		activate_()
	elif Input.is_action_just_pressed("ui_cancel"):
		emit_signal("cancel")
		cancel_sound_.play()

	input_ = false

func up_() -> void:
	if menu_items.empty():
		return

	select_((idx_ - 1) % menu_items.size())

func down_() -> void:
	if menu_items.empty():
		return

	select_((idx_ + 1) % menu_items.size())

func select_(idx, force := false, sound := input_) -> void:
	if idx_ == idx and not force:
		return

	if get_node(menu_items[idx]).off:
		for i in menu_items.size():
			var ii = (idx + i + 1) % menu_items.size()
			if not get_node(menu_items[ii]).off:
				select_(ii, force)
				return

		return

	if menu_items.size() > idx_:
		get_node(menu_items[idx_]).selected = false

	idx_ = idx
	get_node(menu_items[idx_]).selected = true

	if sound:
		select_sound_.play()

func activate_() -> void:
	activate_sound_.play()
	emit_signal(get_node(menu_items[idx_]).name)
	emit_signal("activated", get_node(menu_items[idx_]).get_position_in_parent())
