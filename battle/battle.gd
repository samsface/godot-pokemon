extends Node

signal player_chose_move
signal player_move_applied
signal enemy_move_applied
signal enemy_send_out_pokemon_done
signal player_send_out_pokemon_done

var menu_stack_ := []

var player_pokemon
var rival_pokemon

onready var player_stats_ = find_node("player_stats")
onready var rival_stats_ = find_node("rival_stats")
onready var info_box_ = find_node("info")
onready var action_menu_ = find_node("action_menu")
onready var items_ = find_node("items")
onready var fight_ = find_node("fight_menu")
onready var pokemon_ = find_node("pokemon_list")

onready var player_ = find_node("player")
onready var enemy_ = find_node("enemy")

func _ready():
	rival_pokemon = preload("res://pokemon/beer.tres")
	rival_stats_.text = rival_pokemon.name
	rival_stats_.level = rival_pokemon.level
	rival_stats_.hp = rival_pokemon.hp
	rival_stats_.max_hp = rival_pokemon.max_hp

	player_pokemon = preload("res://pokemon/hat.tres")
	player_stats_.text = player_pokemon.name
	player_stats_.level = player_pokemon.level
	player_stats_.hp = player_pokemon.hp
	player_stats_.max_hp = player_pokemon.max_hp

	action_menu_.set_process_input(false)
	action_menu_.connect("fight", self, "push_menu_", [find_node("fight_menu")])
	action_menu_.connect("item", self, "push_menu_", [items_])
	action_menu_.connect("pokemon", self, "push_menu_", [pokemon_])
	
	fight_.connect("activated", self, "_on_attack_activated")
	fight_.set_process_input(false)
	fight_.clear()
	
	for move in player_pokemon.moves:
		fight_.add_text_menu_item(move.name)

	items_.connect("activated", self, "_on_item_activated")
	items_.set_process_input(false)

	pokemon_.set_process_input(false)

	game_()

func push_menu_(menu) -> void:
	if not menu_stack_.empty():
		menu_stack_.back().visible = false
		menu_stack_.back().set_process_input(false)

	if menu_stack_.size() > 0:
		menu.connect("cancel", self, "pop_menu_", [], CONNECT_ONESHOT)

	menu_stack_.push_back(menu)
	menu.visible = true
	menu.set_process_input(true)

func pop_menu_() -> void:
	if menu_stack_.empty():
		return

	var popped_menu = menu_stack_.pop_back()
	popped_menu.visible = false
	popped_menu.set_process_input(false)
	
	if menu_stack_.empty():
		return
	
	menu_stack_.back().set_process_input(true)
	menu_stack_.back().visible = true

func _on_item_activated(item_idx:int) -> void:
	pop_menu_()

func _on_attack_activated(attack_idx:int) -> void:
	pop_menu_()
	pop_menu_()
	var attack = player_pokemon.moves[attack_idx]
	emit_signal("player_chose_move", attack)
	
func damage_(attacker, defender, move:MoveModel) -> float:
	var t1 = ((2.0 * attacker.level / 5.0) + 2.0)
	var t2 = (attacker.attack / defender.defense)
	var d =  ((t1 * move.power * t2) / 50.0) + 2.0
	return d

func get_next_player_move_():
	push_menu_(action_menu_)
	return self

func get_next_enemy_move_() -> MoveModel:
	return rival_pokemon.moves[round(rand_range(0, rival_pokemon.moves.size() - 1))]

func apply_player_move_(move) -> void:
	if not move:
		return

	info_box_.animate_text("%s used %s!" % [player_pokemon.name, move.name])
	yield(info_box_, "animate_text_done")
	if move.fx:
		var fx = move.fx.instance()
		fx.target_position = $enemy_position.position
		add_child(fx)
		yield(fx, "done")
		fx.queue_free()
	
	var damage = damage_(player_pokemon, rival_pokemon, move)
	var critical = 1.0 if randf() > 0.5 else 2.0
	
	rival_pokemon.hp -= damage * critical
	yield(rival_stats_.animate_hp(rival_pokemon.hp), "animate_hp_done")

	if critical > 1.0:
		info_box_.animate_text("Critical hit!")
		yield(info_box_, "animate_text_done")

	info_box_.clear_text()
	emit_signal("player_move_applied")

func apply_enemy_move_(move) -> void:
	if not move:
		return

	info_box_.animate_text("Enemy %s used %s!" % [rival_pokemon.name, move.name])
	yield(info_box_, "animate_text_done")
	if move.fx:
		var fx = move.fx.instance()
		fx.target_position = $player_position.position
		add_child(fx)
		yield(fx, "done")
		fx.queue_free()
	
	var damage = damage_(rival_pokemon, player_pokemon, move)
	
	var critical = 1.0 if randf() > 0.5 else 2.0

	player_pokemon.hp -= damage * critical
	yield(player_stats_.animate_hp(player_pokemon.hp), "animate_hp_done")
	
	if critical > 1.0:
		info_box_.animate_text("Critical hit!")
		yield(info_box_, "animate_text_done")

	info_box_.clear_text()
	emit_signal("enemy_move_applied")

func enemy_send_out_pokemon_() -> void:
	$tween.interpolate_property(enemy_, "position:x", null, 160, 0.2)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Dude send out beer!"), "animate_text_done")
	$enemy_position/pokemon.visible = true
	rival_stats_.visible = true
	info_box_.clear_text()
	emit_signal("enemy_send_out_pokemon_done")

func player_send_out_pokemon_() -> void:
	$tween.interpolate_property(player_, "position:x", null, -100, 0.2)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Go Hat!"), "animate_text_done")
	$player_position/pokemon.visible = true
	player_stats_.visible = true
	info_box_.clear_text()
	emit_signal("player_send_out_pokemon_done")

func game_() -> void:
	$tween.interpolate_property(player_, "position:x", 144, player_.position.x, 1.0)
	$tween.interpolate_property(enemy_, "position:x", -144, enemy_.position.x, 1.0)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Dude wants to fight!"), "animate_text_done")

	enemy_send_out_pokemon_()
	yield(self, "enemy_send_out_pokemon_done")
	
	player_send_out_pokemon_()
	yield(self, "player_send_out_pokemon_done")

	while true:
		var player_move = yield(get_next_player_move_(), "player_chose_move")
		var enemy_move = get_next_enemy_move_()
		
		apply_player_move_(player_move)
		yield(self, "player_move_applied")
		
		if rival_pokemon.hp <= 0:
			yield(info_box_.animate_text("Enemy fainted."), "animate_text_done")
			return

		apply_enemy_move_(enemy_move)
		yield(self, "enemy_move_applied")
