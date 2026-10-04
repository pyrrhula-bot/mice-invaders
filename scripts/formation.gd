extends RefCounted

var positions: Array[Vector2] = []
var direction: int = 1
var total: int = 0

var _base_speed: float = 40.0
var _speed_step: float = 4.0
var _spacing: Vector2 = Vector2.ZERO


func setup(rows: int, columns: int, spacing: Vector2, origin: Vector2) -> void:
	positions.clear()
	direction = 1
	_spacing = spacing
	for row in range(rows):
		for col in range(columns):
			positions.append(origin + Vector2(col * spacing.x, row * spacing.y))
	total = positions.size()


func step(left_bound: float, right_bound: float) -> void:
	if positions.is_empty():
		return
	var dx: float = get_speed() * direction
	for pos in positions:
		var new_x: float = pos.x + dx
		if new_x < left_bound or new_x > right_bound:
			_drop_row()
			return
	for i in range(positions.size()):
		positions[i] += Vector2(dx, 0.0)


func _drop_row() -> void:
	direction *= -1
	for i in range(positions.size()):
		positions[i] += Vector2(0.0, _spacing.y)


func get_speed() -> float:
	var remaining: int = positions.size()
	if remaining <= 0:
		return _base_speed
	return _base_speed + _speed_step * (total - remaining)


func remove_mouse(index: int) -> void:
	positions.remove_at(index)


func mouse_count() -> int:
	return positions.size()
