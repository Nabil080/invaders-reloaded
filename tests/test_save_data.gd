## Run with: godot --headless --script res://tests/test_save_data.gd
extends SceneTree

var failures := 0


func _init() -> void:
	test_first_game_sets_every_record()
	test_records_and_averages_over_two_games()
	test_zero_score_stays_the_worst()
	print("%d failure(s)" % failures)
	quit(1 if failures else 0)


func test_first_game_sets_every_record() -> void:
	var totals := SaveData.new()
	totals.add_game(_game(120, 30.0, 2))
	_check(totals.games_played == 1, "games played")
	_check(totals.score_best == 120 and totals.score_worst == 120, "first score is best and worst")
	_check(totals.playtime_longest == 30.0 and totals.playtime_shortest == 30.0, "first playtime is longest and shortest")
	_check(totals.biggest_wave == 2, "biggest wave")


func test_records_and_averages_over_two_games() -> void:
	var totals := SaveData.new()
	totals.add_game(_game(120, 30.0, 2))
	totals.add_game(_game(40, 90.0, 1))
	_check(totals.score_total == 160, "score total")
	_check(totals.score_best == 120 and totals.score_worst == 40, "best and worst score")
	_check(is_equal_approx(totals.score_average, 80.0), "score average")
	_check(totals.playtime_longest == 90.0 and totals.playtime_shortest == 30.0, "longest and shortest game")
	_check(is_equal_approx(totals.playtime_average, 60.0), "playtime average")
	_check(totals.waves_cleared == 3 and totals.biggest_wave == 2, "waves")


func test_zero_score_stays_the_worst() -> void:
	var totals := SaveData.new()
	totals.add_game(_game(0, 5.0, 0))
	totals.add_game(_game(80, 20.0, 0))
	_check(totals.score_worst == 0, "a game at 0 points stays the worst")


func _game(score: int, playtime: float, waves: int) -> SaveData:
	var game := SaveData.new()
	game.games_played = 1
	game.score_total = score
	game.playtime_total = playtime
	game.waves_cleared = waves
	return game


func _check(condition: bool, label: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL: " + label)
