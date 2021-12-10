extends Control
class_name Menu

signal activated
signal cancel

export(Array, NodePath) var menu_items

var idx_ := 0

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
	for path in menu_items:
		add_user_signal(get_node(path).name)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		up_()
	elif Input.is_action_just_pressed("ui_down"):
		down_()
	elif Input.is_action_just_pressed("ui_select"):
		activate_()
	elif Input.is_action_just_pressed("ui_cancel"):
		emit_signal("cancel")

func up_() -> void:
	if menu_items.empty():
		return

	select_((idx_ - 1) % menu_items.size())

func down_() -> void:
	if menu_items.empty():
		return

	select_((idx_ + 1) % menu_items.size())

func select_(idx, force := false) -> void:
	if idx_ == idx and not force:
		return

	get_node(menu_items[idx_]).selected = false
	idx_ = idx
	get_node(menu_items[idx_]).selected = true

func activate_() -> void:
	emit_signal(get_node(menu_items[idx_]).name)
	emit_signal("activated", get_node(menu_items[idx_]).get_position_in_parent())
