class_name GameOverlay
extends Control

@onready var score_value: Label = $Panel/ScoreContainer/ScoreValue
@onready var lives_value: Label = $Panel/LivesContainer/LivesValue
@onready var wave_value: Label = $Panel/WaveContainer/WaveValue
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var difficulty_label: RichTextLabel = $DifficultyIncreaseLabel


func _ready() -> void:
	_play_falling_star(randf_range(5.0, 20.0))


## Called by the FallingStar animation when it ends, to queue the next one.
func falling_star() -> void:
	_play_falling_star(randf_range(15.0, 60.0))


func update_score(score: int) -> void:
	score_value.text = str(score)


func update_lives(lives: int) -> void:
	lives_value.text = str(lives)


func update_wave(wave: int) -> void:
	wave_value.text = str(wave)
	difficulty_label.visible = true
	await get_tree().create_timer(2).timeout
	difficulty_label.visible = false


func _play_falling_star(delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	animation_player.play("FallingStar")
	SaveLoad.data.shooting_stars += 1
