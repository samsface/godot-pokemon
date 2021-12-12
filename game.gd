extends Node2D

onready var info = find_node("info")

func _ready():
	while true:
		yield(info.set_text_for_confirm("Press [SPACE] to confirm!"), "done")
		yield(info.set_text_for_confirm("Press [P] to pause"), "done")
		yield(info.set_text_for_confirm("Use the arrow keys to navigate menus."), "done")
		
		yield(info.set_text_for_confirm("Are you ready to be a pokemon master?"), "done")
		info.clear_text()
		yield(get_tree().create_timer(0.5), "timeout")
		var transition = $transition.create_instance()
		transition.start()
		yield(transition, "done")
		$music.play()
		yield(get_tree().create_timer(0.8), "timeout")
		transition.queue_free()
		var battle = $battle.create_instance()
		yield(battle, "done")
		battle.queue_free()
