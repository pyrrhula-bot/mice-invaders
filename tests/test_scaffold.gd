# The scaffold's own test, and the shape every later one copies.
#
# It is here so that `godot --headless --path . --script tests/run_tests.gd` is green on a
# fresh clone. That matters more than it looks: a delegated agent runs the test command
# before and after its own work, and a scaffold whose suite fails from the start gives it
# a failure to chase that has nothing to do with the task.
#
# Delete it once there are real tests.
extends "res://tests/test_case.gd"


func test_the_suite_runs_at_all() -> void:
	assert_true(true, "the runner found and executed this file")


func test_assertions_report_what_they_compared() -> void:
	# Exercising the helper against itself, so a broken assertion cannot pass silently.
	var probe = load("res://tests/test_case.gd").new()
	probe.assert_eq(1, 2, "deliberate")
	assert_eq(probe.failures.size(), 1, "a mismatch records exactly one failure")
	assert_true(str(probe.failures[0]).contains("expected 2"), "and says what it expected")
