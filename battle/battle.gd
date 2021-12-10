extends Node

signal player_chose_move
signal player_move_applied
signal enemy_move_applied
signal enemy_send_out_pokemon_done
signal player_send_out_pokemon_done

export(Resource) var player
export(Resource) var enemy

onready var player_stats_ = find_node("player_stats")
onready var rival_stats_ = find_node("rival_stats")
onready var info_box_ = find_node("info")
onready var action_menu_ = find_node("action_menu")
onready var items_ = find_node("items")
onready var fight_ = find_node("fight_menu")
onready var pokemon_ = find_node("pokemon_list")

onready var player_ = find_node("player")
onready var enemy_ = find_node("enemy")

var menu_stack_ := []

var player_pokemon_graphic_
var player_pokemon_
var enemy_pokemon_graphic_
var enemy_pokemon_

func _ready():
	action_menu_.set_process_input(false)
	action_menu_.connect("fight", self, "push_menu_", [find_node("fight_menu")])
	action_menu_.connect("item", self, "push_menu_", [items_])
	action_menu_.connect("pokemon", self, "push_menu_", [pokemon_])

	fight_.connect("activated", self, "_on_attack_activated")
	fight_.set_process_input(false)

	items_.connect("activated", self, "_on_item_activated")
	items_.set_process_input(false)

	pokemon_.pokemon = player.pokemon
	pokemon_.set_process_input(false)
	pokemon_.connect("activated", self, "_on_pokemon_select_activated")

	game_()

func set_player_pokemon_(pokemon) -> void:
	if player_pokemon_graphic_:
		player_pokemon_graphic_.queue_free()

	player_pokemon_graphic_ = $player_position/pokemon/pokemon.create_instance(false, pokemon.battle_graphics)
	player_pokemon_graphic_.show_back()
	
	player_pokemon_ = pokemon
	player_stats_.text = player_pokemon_.name
	player_stats_.level = player_pokemon_.level
	player_stats_.hp = player_pokemon_.hp
	player_stats_.max_hp = player_pokemon_.max_hp
	
	fight_.clear()
	
	for move in player_pokemon_.moves:
		fight_.add_text_menu_item(move.name)

func set_enemy_pokemon_(pokemon) -> void:
	if enemy_pokemon_graphic_:
		enemy_pokemon_graphic_.queue_free()

	enemy_pokemon_graphic_ = $enemy_position/pokemon/pokemon.create_instance(false, pokemon.battle_graphics)
	enemy_pokemon_graphic_.show_front()
	
	enemy_pokemon_ = pokemon
	rival_stats_.text = enemy_pokemon_.name
	rival_stats_.level = enemy_pokemon_.level
	rival_stats_.hp = enemy_pokemon_.hp
	rival_stats_.max_hp = enemy_pokemon_.max_hp

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
	var attack = player_pokemon_.moves[attack_idx]
	emit_signal("player_chose_move", { "attack": attack })
	
func _on_pokemon_select_activated(pokemon_idx:int) -> void:
	pop_menu_()
	pop_menu_()
	emit_signal("player_chose_move", { "pokemon": pokemon_idx })
	
func damage_(attacker, defender, move:MoveModel) -> float:
	var t1 = ((2.0 * attacker.level / 5.0) + 2.0)
	var t2 = (attacker.attack / defender.defense)
	var d =  ((t1 * move.power * t2) / 50.0) + 2.0
	return d

func get_next_player_move_():
	push_menu_(action_menu_)
	return self

func get_next_enemy_move_() -> MoveModel:
	return enemy_pokemon_.moves[round(rand_range(0, enemy_pokemon_.moves.size() - 1))]

func apply_player_pokemon_(pokemon_idx:int) -> void:
	player_send_out_pokemon_(player.pokemon[pokemon_idx])
	yield(self, "player_send_out_pokemon_done")

	emit_signal("player_move_applied")

func apply_player_move_(move) -> void:
	if not move:
		return

	info_box_.animate_text("%s used %s!" % [player_pokemon_.name, move.name])
	yield(info_box_, "animate_text_done")
	if move.fx:
		var fx = move.fx.instance()
		fx.target_position = $enemy_position.position
		add_child(fx)
		yield(fx, "done")
		fx.queue_free()
	
	var damage = damage_(player_pokemon_, enemy_pokemon_, move)
	var critical = 1.0 if randf() > 0.5 else 2.0
	
	enemy_pokemon_.hp -= damage * critical
	yield(rival_stats_.animate_hp(enemy_pokemon_.hp), "animate_hp_done")

	if critical > 1.0:
		info_box_.animate_text("Critical hit!")
		yield(info_box_, "animate_text_done")

	info_box_.clear_text()
	emit_signal("player_move_applied")

func apply_enemy_move_(move) -> void:
	if not move:
		return

	info_box_.animate_text("Enemy %s used %s!" % [enemy_pokemon_.name, move.name])
	yield(info_box_, "animate_text_done")
	if move.fx:
		var fx = move.fx.instance()
		fx.target_position = $player_position.position
		add_child(fx)
		yield(fx, "done")
		fx.queue_free()
	
	var damage = damage_(enemy_pokemon_, player_pokemon_, move)
	
	var critical = 1.0 if randf() > 0.5 else 2.0

	player_pokemon_.hp -= damage * critical
	yield(player_stats_.animate_hp(player_pokemon_.hp), "animate_hp_done")
	
	if critical > 1.0:
		info_box_.animate_text("Critical hit!")
		yield(info_box_, "animate_text_done")

	info_box_.clear_text()
	emit_signal("enemy_move_applied")

func swap_player_pokemon_() -> void:
	pass

func enemy_send_out_pokemon_(pokemon) -> void:
	if enemy_pokemon_:
		yield(enemy_pokemon_graphic_.withdraw(), "done")

	set_enemy_pokemon_(pokemon)
	yield(enemy_pokemon_graphic_.enter(), "done")

	$tween.interpolate_property(enemy_, "position:x", null, 160, 0.2)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Dude send out beer!"), "animate_text_done")
	$enemy_position/pokemon.visible = true
	rival_stats_.visible = true
	info_box_.clear_text()
	emit_signal("enemy_send_out_pokemon_done")

func player_send_out_pokemon_(pokemon) -> void:
	if player_pokemon_:
		yield(info_box_.animate_text("Enough! Come back!"), "animate_text_done")
		yield(player_pokemon_graphic_.withdraw(), "done")
	
	set_player_pokemon_(pokemon)
	yield(player_pokemon_graphic_.enter(), "done")

	$tween.interpolate_property(player_, "position:x", null, -100, 0.2)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Go %s" % player_pokemon_.name), "animate_text_done")
	$player_position/pokemon.visible = true
	player_stats_.visible = true
	info_box_.clear_text()
	emit_signal("player_send_out_pokemon_done")

func game_() -> void:
	$tween.interpolate_property(player_, "position:x", 144, player_.position.x, 1.0)
	$tween.interpolate_property(enemy_, "position:x", -144, enemy_.position.x, 1.0)
	yield($tween.block(), "done")

	yield(info_box_.animate_text("Dude wants to fight!"), "animate_text_done")

	enemy_send_out_pokemon_(enemy.pokemon[0])
	yield(self, "enemy_send_out_pokemon_done")
	
	player_send_out_pokemon_(player.pokemon[0])
	yield(self, "player_send_out_pokemon_done")

	while true:
		var player_move = yield(get_next_player_move_(), "player_chose_move")
		var enemy_move = get_next_enemy_move_()
		
		if player_move.has("attack"):
			apply_player_move_(player_move.attack)
			yield(self, "player_move_applied")
		else:
			apply_player_pokemon_(player_move.pokemon)
			yield(self, "player_move_applied")

		if enemy_pokemon_.hp <= 0:
			yield(info_box_.animate_text("Enemy fainted."), "animate_text_done")
			yield(enemy_pokemon_graphic_.faint(), "done")
			enemy_send_out_pokemon_(enemy.pokemon[1])
			yield(self, "enemy_send_out_pokemon_done")
			continue
			
		apply_enemy_move_(enemy_move)
		yield(self, "enemy_move_applied")
		
		if player_pokemon_.hp <= 0:
			yield(info_box_.animate_text("%s fainted." % player_pokemon_.name), "animate_text_done")
			yield(player_pokemon_graphic_.faint(), "done")
			push_menu_(pokemon_)
			info_box_.clear_text()
			player_move = yield(self, "player_chose_move")
			apply_player_pokemon_(player_move.pokemon)
			yield(self, "player_move_applied")

			continue


