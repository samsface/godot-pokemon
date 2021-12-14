extends Node2D

onready var info = find_node("info")

func _ready():
	while true:
		yield(info.set_text_for_confirm("Press [SPACE] to confirm. OK?"), "done")
		yield(info.set_text_for_confirm("Press [P] to pause. OK?"), "done")
		yield(info.set_text_for_confirm("Use the arrow keys to navigate menus. OK?"), "done")
		
		yield(info.set_text_for_confirm("You are at a stranger's funeral."), "done")
		yield(info.set_text_for_confirm("You begin to randomly insult people."), "done")
		yield(info.set_text_for_confirm("Some Cry Baby speaks up..."), "done")

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

		var ka = battle.player
		battle.enemy.pokemon[0].hp = battle.enemy.pokemon[0].max_hp
		battle.player.pokemon.push_back(battle.enemy.pokemon[0])
		battle.queue_free()
		
		yield(get_tree().create_timer(0.8), "timeout")
		yield(info.set_text_for_confirm("You steal the Cry Baby's hat..."), "done")

		yield(info.set_text_for_confirm("... and keep insulting people but louder now."), "done")
		yield(info.set_text_for_confirm("You're about to land the perfect insult..."), "done")
		yield(info.set_text_for_confirm("...on a grieving sibling."), "done")
		yield(info.set_text_for_confirm("But a figure with a skull head stops you!"), "done")

		transition = $transition.create_instance()
		transition.start()
		yield(transition, "done")
		transition.queue_free()

		var battle2 = $battle2.create_instance()
		yield(battle2, "done")
		battle2.queue_free()
		
		yield(info.set_text_for_confirm("You climb on the church's electric organ."), "done")
		yield(info.set_text_for_confirm("And begin to play chopsticks badly."), "done")
		yield(info.set_text_for_confirm("Some jackass plugs the organ out."), "done")

		transition = $transition.create_instance()
		transition.start()
		yield(transition, "done")
		transition.queue_free()

		var battle3 = $battle3.create_instance()
		yield(battle3, "done")
		battle3.queue_free()
	
