## Lifetime statistics. One instance holds a single game, another the totals
## saved on disk.
class_name SaveData
extends Resource

@export_group("Games")
@export var games_played: int = 0

@export_group("Score")
@export var score_total: int = 0
@export var score_best: int = 0
@export var score_worst: int = 0
@export var score_average: float = 0.0

@export_group("Playtime")
@export var playtime_total: float = 0.0
@export var playtime_longest: float = 0.0
@export var playtime_shortest: float = 0.0
@export var playtime_average: float = 0.0

@export_group("Kills")
@export var kills_shield: int = 0
@export var kills_middle: int = 0
@export var kills_back: int = 0
@export var kills_ufo: int = 0

@export_group("Shots")
@export var shots_fired: int = 0
@export var shots_clashed: int = 0
@export var shots_returned: int = 0
@export var shots_bunker: int = 0

@export_group("Others")
@export var lives_lost: int = 0
@export var shooting_stars: int = 0
@export var waves_cleared: int = 0
@export var biggest_wave: int = 0


func add_game(game: SaveData) -> void:
	games_played += game.games_played

	score_total += game.score_total
	score_best = max(game.score_total, score_best)
	score_worst = min(game.score_total, score_worst) if games_played > 1 else game.score_total
	score_average = float(score_total) / games_played

	playtime_total += game.playtime_total
	playtime_longest = max(game.playtime_total, playtime_longest)
	playtime_shortest = min(game.playtime_total, playtime_shortest) if games_played > 1 else game.playtime_total
	playtime_average = playtime_total / games_played

	kills_shield += game.kills_shield
	kills_middle += game.kills_middle
	kills_back += game.kills_back
	kills_ufo += game.kills_ufo

	shots_fired += game.shots_fired
	shots_clashed += game.shots_clashed
	shots_returned += game.shots_returned
	shots_bunker += game.shots_bunker

	lives_lost += game.lives_lost
	shooting_stars += game.shooting_stars
	waves_cleared += game.waves_cleared
	biggest_wave = max(game.waves_cleared, biggest_wave)
