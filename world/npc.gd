extends Node2D

signal encounter
signal beat

export(Resource) var trainer setget set_trainer

func _ready() -> void:
	for node in get_children():
		if node is Trigger:
			node.connect("trigger", self, "emit_signal", ["encounter"])

func set_trainer(value) -> void:
	trainer = value
	$sprite.call_deferred("create_instance", true, trainer.world_graphic)
