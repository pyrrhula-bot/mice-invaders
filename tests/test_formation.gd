extends "res://tests/test_case.gd"

const Formation = preload("res://scripts/formation.gd")


func test_initial_layout_creates_grid() -> void:
	var formation := Formation.new()
	formation.setup(2, 3, Vector2(50, 40), Vector2(100, 100))
	assert_eq(formation.mouse_count(), 6, "2 rows x 3 columns = 6 mice")
	assert_eq(formation.positions[0], Vector2(100, 100), "first mouse at origin")
	assert_eq(formation.positions[1], Vector2(150, 100), "second mouse one column right")
	assert_eq(formation.positions[2], Vector2(200, 100), "third mouse two columns right")
	assert_eq(formation.positions[3], Vector2(100, 140), "fourth mouse one row down")
	assert_eq(formation.positions[4], Vector2(150, 140), "fifth mouse one row down, one column right")
	assert_eq(formation.positions[5], Vector2(200, 140), "sixth mouse one row down, two columns right")


func test_step_moves_sideways_without_dropping() -> void:
	var formation := Formation.new()
	formation.setup(1, 2, Vector2(50, 40), Vector2(100, 100))
	var initial_y: float = formation.positions[0].y
	formation.step(50, 300)
	assert_almost_eq(formation.positions[0].x, 140.0, 0.01, "first mouse moved right by speed")
	assert_almost_eq(formation.positions[1].x, 190.0, 0.01, "second mouse moved right by speed")
	assert_almost_eq(formation.positions[0].y, initial_y, 0.01, "y position unchanged")
	assert_eq(formation.direction, 1, "direction still positive")


func test_step_past_right_edge_drops_row_and_reverses() -> void:
	var formation := Formation.new()
	formation.setup(1, 2, Vector2(50, 40), Vector2(280, 100))
	var initial_y: float = formation.positions[0].y
	formation.step(50, 300)
	assert_almost_eq(formation.positions[0].y, initial_y + 40.0, 0.01, "dropped one row")
	assert_almost_eq(formation.positions[0].x, 280.0, 0.01, "x position unchanged after drop")
	assert_eq(formation.direction, -1, "direction reversed to negative")


func test_step_past_left_edge_drops_row_and_reverses() -> void:
	var formation := Formation.new()
	formation.setup(1, 2, Vector2(50, 40), Vector2(80, 100))
	formation.direction = -1
	var initial_y: float = formation.positions[0].y
	formation.step(50, 300)
	assert_almost_eq(formation.positions[0].y, initial_y + 40.0, 0.01, "dropped one row")
	assert_almost_eq(formation.positions[0].x, 80.0, 0.01, "x position unchanged after drop")
	assert_eq(formation.direction, 1, "direction reversed to positive")


func test_speed_increases_as_mice_destroyed() -> void:
	var formation := Formation.new()
	formation.setup(2, 3, Vector2(50, 40), Vector2(100, 100))
	var full_speed: float = formation.get_speed()
	assert_almost_eq(full_speed, 40.0, 0.01, "full strength speed is base_speed")
	formation.remove_mouse(0)
	formation.remove_mouse(1)
	formation.remove_mouse(2)
	var half_speed: float = formation.get_speed()
	assert_almost_eq(half_speed, 52.0, 0.01, "half strength speed is base + 3 steps")
	assert_true(half_speed > full_speed, "half strength is faster than full")
	for i in range(formation.mouse_count() - 1, 0, -1):
		formation.remove_mouse(i)
	var last_speed: float = formation.get_speed()
	assert_almost_eq(last_speed, 60.0, 0.01, "one mouse left is base + 5 steps")
	assert_true(last_speed > half_speed, "one mouse is faster than half strength")
