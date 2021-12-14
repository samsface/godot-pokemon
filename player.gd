extends Node2D

const tile_size = 16.0

const animation_ = {
	Vector2.ZERO: "idle",
	Vector2.LEFT: "west",
	Vector2.RIGHT: "east",
	Vector2.DOWN: "south",
	Vector2.UP: "north"
}

onready var ray_:RayCast2D = $ray
onready var moves_ := []
var moving_to_

var pause_controls := false

func _ready() -> void:
	pass

func floor_vec2(vector:Vector2) -> Vector2:
	return Vector2(round(vector.x / 16.0) * 16.0, round(vector.y / 16.0) * 16.0)

func _process(delta:float):
	var direction := Vector2()

	if not pause_controls:
		if Input.is_action_pressed("ui_down"):
			direction = Vector2.DOWN

		if Input.is_action_pressed("ui_up"):
			direction = Vector2.UP

		if Input.is_action_pressed("ui_left"):
			direction = Vector2.LEFT

		if Input.is_action_pressed("ui_right"):
			direction = Vector2.RIGHT

		if direction != Vector2():
			if moves_.find(direction) == -1:
				moves_.push_back(direction)

	if moving_to_ == null and not moves_.empty():
		ray_.rotation = moves_.front().angle()
		ray_.force_raycast_update()
		if ray_.is_colliding():
			$animation.animation = animation_[moves_.front()]
			moves_.pop_front()
		else:
			moving_to_ = floor_vec2(global_position) + moves_.front() * tile_size

	if not moves_.empty():
		$animation.animation = animation_[moves_.front()]
		global_position = global_position.move_toward(moving_to_, delta * 20.0)
		if global_position.distance_to(moving_to_) <= 0.1:
			global_position = moving_to_
			moving_to_ = null
			moves_.pop_front()
