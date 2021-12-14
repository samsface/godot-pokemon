extends Area2D

signal encounter

export(Resource) var trainer

func _on_area_entered(area):
	emit_signal("encounter")

