extends Node2D

onready var info = find_node("info")

func _ready():
	while true:
		yield(info.set_text_for_confirm("Press [SPACE] to confirm. OK?"), "done")
		yield(info.set_text_for_confirm("Press [P] to pause. OK?"), "done")
		yield(info.set_text_for_confirm("Use the arrow keys to navigate menus. OK?"), "done")
		
		yield(info.set_text_for_confirm("Are you ready to be a HATeMON master?"), "done")
		info.clear_text()
		yield(get_tree().create_timer(0.2), "timeout")
		var transition = $transition.create_instance()
		transition.start()
		yield(transition, "done")
		$music.play()
		yield(get_tree().create_timer(0.8), "timeout")
		transition.queue_free()
		var battle = $battle.create_instance()
		yield(battle, "done")
		
		battle.enemy.pokemon[0].hp = battle.enemy.pokemon[0].max_hp
		battle.player.pokemon.push_back(battle.enemy.pokemon[0])
		
		battle.queue_free()
		
		

		var battle2 = $battle2.create_instance()
		yield(battle2, "done")
		battle2.queue_free()
