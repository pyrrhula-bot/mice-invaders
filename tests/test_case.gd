# The whole assertion vocabulary, on purpose.
#
# A delegated agent has to be able to write a test file without reading a framework's
# documentation first, and a reader has to be able to see what a failure means without
# leaving this file. Four assertions cover everything the pure game logic needs; reach for
# a real framework (GUT, gdUnit4) when the project outgrows them, not before.
#
# A test file extends this, and every method whose name begins with `test_` is run.
extends RefCounted

var failures: Array[String] = []


func assert_eq(actual, expected, what: String = "") -> void:
	if actual != expected:
		failures.append("%s: expected %s, got %s" % [what, expected, actual])


func assert_ne(actual, unexpected, what: String = "") -> void:
	if actual == unexpected:
		failures.append("%s: expected anything but %s" % [what, unexpected])


func assert_true(value: bool, what: String = "") -> void:
	if not value:
		failures.append("%s: expected true, got false" % what)


func assert_false(value: bool, what: String = "") -> void:
	if value:
		failures.append("%s: expected false, got true" % what)


func assert_almost_eq(actual: float, expected: float, epsilon: float = 0.0001, what: String = "") -> void:
	if absf(actual - expected) > epsilon:
		failures.append("%s: expected %f +/- %f, got %f" % [what, expected, epsilon, actual])
