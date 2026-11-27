extends CanvasLayer

@onready var stats: Control = $Panel/VBoxContainer/Stats


func _ready() -> void:
	_show_stats()


func _show_stats() -> void:
	var data := SaveLoad.data
	$Panel/GamesLabel.text = "%d games" % data.games_played

	_set_value("Score/Best", str(data.score_best))
	_set_value("Score/Worst", str(data.score_worst))
	_set_value("Score/Total", str(data.score_total))
	_set_value("Score/Average", str(int(data.score_average)))

	_set_value("Playtime/Total", "%ds" % data.playtime_total)
	_set_value("Playtime/Longest", "%ds" % data.playtime_longest)
	_set_value("Playtime/Shortest", "%ds" % data.playtime_shortest)
	_set_value("Playtime/Average", "%ds" % data.playtime_average)

	_set_value("Kills/Shield", str(data.kills_shield))
	_set_value("Kills/Middle", str(data.kills_middle))
	_set_value("Kills/Back", str(data.kills_back))
	_set_value("Kills/UFO", str(data.kills_ufo))

	_set_value("Shots/Fired", str(data.shots_fired))
	_set_value("Shots/Clashed", str(data.shots_clashed))
	_set_value("Shots/Returned", str(data.shots_returned))
	_set_value("Shots/Bunker", str(data.shots_bunker))

	_set_value("Others/LivesLost", str(data.lives_lost))
	_set_value("Others/ShootingStars", str(data.shooting_stars))
	_set_value("Others/WavesCleared", str(data.waves_cleared))
	_set_value("Others/BiggestWave", str(data.biggest_wave))


func _set_value(row: String, value: String) -> void:
	stats.get_node(row + "/Value").text = value


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")


func _on_reset_button_pressed() -> void:
	SaveLoad.reset()
	_show_stats()
