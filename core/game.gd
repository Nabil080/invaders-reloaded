extends Node2D

@onready var game_overlay: GameOverlay = $GameOverlay
@onready var enemy_manager: Node2D = $EnemyManager
@onready var player: Player = $Player

var lives := 3:
	set(value):
		lives = value
		game_overlay.update_lives(lives)
var shots_before_ufo := 28

var game_data := SaveData.new()


func _ready() -> void:
	game_overlay.update_score(game_data.score_total)
	game_overlay.update_lives(lives)


func _process(delta: float) -> void:
	game_data.playtime_total += delta


func _game_over() -> void:
	get_tree().paused = true
	$GameOverMenu.show()
	_save_game()


# Every started game counts, even one left from the pause menu
func _save_game() -> void:
	if game_data.playtime_total == 0.0:
		return
	game_data.games_played = 1
	SaveLoad.add_game(game_data)
	# Fresh data so the save on exit doesn't count this game twice
	game_data = SaveData.new()


func _on_player_player_shot() -> void:
	game_data.shots_fired += 1
	shots_before_ufo -= 1
	if shots_before_ufo == 0:
		enemy_manager.spawn_mothership()
		shots_before_ufo = 20


func _on_enemy_manager_enemy_died(enemy: Enemy) -> void:
	game_data.score_total += enemy.data.score
	# Each enemy type has its own score
	match enemy.data.score:
		10:
			game_data.kills_shield += 1
		15:
			game_data.kills_middle += 1
		25:
			game_data.kills_back += 1
		150:
			game_data.kills_ufo += 1
	game_overlay.update_score(game_data.score_total)


func _on_enemy_manager_wave_cleared() -> void:
	game_data.waves_cleared += 1
	game_overlay.update_wave(game_data.waves_cleared)


func _on_player_death_started() -> void:
	game_data.lives_lost += 1
	lives -= 1
	if lives < 1:
		_game_over()
	get_tree().paused = true


func _on_player_death_ended() -> void:
	if lives < 1:
		return
	player.reset()
	player.make_invulnerable()
	get_tree().paused = false


func _on_goal_body_entered(_body: Node2D) -> void:
	_game_over()


func _on_pause_menu_color_changed(color: Color) -> void:
	player.modulate = color


func _on_tree_exiting() -> void:
	_save_game()
