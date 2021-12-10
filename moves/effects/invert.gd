extends ColorRect

export(float, 0.0, 1.0) var value setget set_value

func set_value(v:float) -> void:
	value = v
	material.set_shader_param("value", value)
