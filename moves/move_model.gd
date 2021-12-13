extends Resource
class_name MoveModel

enum Type {
	normal,
	fire,
	water,
	electric
}

export(String) var name
export(int) var power = 1
export(float) var accuracy = 1.0
export(Type) var type
export(PackedScene) var fx
