# The test entry point:  godot --headless --path . --script tests/run_tests.gd
#
# It exists because a delegated coding agent verifies itself by running the repository's
# own test command in a container with no display. That means the runner has to (a) find
# tests without being told, (b) print what failed rather than only that something did, and
# (c) exit non-zero -- an exit code is the only thing the pipeline reads.
#
# Deliberately not a framework. Every file `tests/test_*.gd` is loaded, instantiated, and
# every method on it named `test_*` is called; assertions append to `failures` (see
# test_case.gd). Adding a test is adding a file.
extends SceneTree

const TESTS_DIR := "res://tests"


func _initialize() -> void:
	var files := _test_files()
	if files.is_empty():
		# Not a pass. A suite that finds nothing looks exactly like a suite that passes,
		# and that is how a green build comes to mean nothing at all.
		print("no test files found in %s -- nothing was verified" % TESTS_DIR)
		quit(1)
		return

	var total := 0
	var failed := 0
	for file in files:
		var script := load("%s/%s" % [TESTS_DIR, file])
		if script == null:
			print("FAIL %s: could not be loaded" % file)
			failed += 1
			continue
		for method in script.new().get_method_list():
			var name: String = method.get("name", "")
			if not name.begins_with("test_"):
				continue
			total += 1
			# A fresh instance per test: state left behind by one case is the classic way
			# a suite passes in one order and fails in another.
			var suite = script.new()
			suite.callv(name, [])
			if suite.failures.is_empty():
				print("  ok   %s::%s" % [file, name])
			else:
				failed += 1
				print("  FAIL %s::%s" % [file, name])
				for failure in suite.failures:
					print("         %s" % failure)

	print("\n%d test(s), %d failed" % [total, failed])
	quit(1 if failed > 0 else 0)


func _test_files() -> Array[String]:
	var found: Array[String] = []
	var dir := DirAccess.open(TESTS_DIR)
	if dir == null:
		return found
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if not dir.current_is_dir() and entry.begins_with("test_") and entry.ends_with(".gd"):
			# test_case.gd is the base class, not a case.
			if entry != "test_case.gd":
				found.append(entry)
		entry = dir.get_next()
	dir.list_dir_end()
	found.sort()
	return found
