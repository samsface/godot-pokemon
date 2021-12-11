extends Node2D


onready var info = find_node("info")

func _ready():
	while true:
		yield(info.set_text("Are you ready to be a pokemon master?"), "done")
		var transition = $transition.create_instance()
		transition.start()
		yield(transition, "done")
		yield(get_tree().create_timer(1.0), "timeout")
		transition.queue_free()
		var battle = $battle.create_instance()
		yield(battle, "done")
		battle.queue_free()
