## Spawns the waves, moves them and speeds them up.
extends Node2D

signal enemy_died(enemy: Enemy)
signal wave_cleared

const ENEMY := preload("uid://bvmedqp2lxlch")
const BACK_ENEMY := preload("uid://wcvrrcjqjvl6")
const BASE_ENEMY := preload("uid://dmk4p362227qu")
const MOTHERSHIP := preload("uid://01hsyjr14ivb")
const SHIELD_ENEMY := preload("uid://c87bvplxwqo0n")
const MOTHERSHIP_SOUND := preload("uid://dxqvbnifv3hr")

const ENEMY_ROWS := [BACK_ENEMY, BASE_ENEMY, BASE_ENEMY, SHIELD_ENEMY]
const COLS := 10
const ENEMY_SIZE := Vector2(13.0, 6.0)
const ROW_GAP := 4.0
const COL_GAP := 4.0

@export_group("Difficulty")
## Multiplies the enemies' shot cooldown on the first wave.
@export var difficulty_start := 2.0
## Taken off the multiplier after each wave.
@export var difficulty_ramp := 0.25
## Lowest multiplier, the fastest enemies can shoot.
@export var difficulty_min := 0.25

var difficulty := difficulty_start
var direction := Vector2.RIGHT
var wall_was_hit := false

@onready var enemies_marker: Marker2D = $EnemiesMarker
@onready var mothership_marker: Marker2D = $MothershipMarker
@onready var movement_timer: Timer = $MovementTimer
@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	spawn_enemies()


func spawn_enemies() -> void:
	movement_timer.stop()
	enemies_marker.position = Vector2.ZERO
	var start := -((COLS * ENEMY_SIZE.x + ((COLS - 4) * COL_GAP)) / 2)
	var enemy_position := Vector2.ZERO

	for enemy_data in ENEMY_ROWS:
		for i in range(COLS):
			enemy_position.x = start + (i * (ENEMY_SIZE.x + COL_GAP))
			spawn_enemy(enemy_data, enemy_position)
		enemy_position.y += ENEMY_SIZE.y + ROW_GAP

	movement_timer.wait_time = 1.0
	movement_timer.start()
	difficulty = max(difficulty - difficulty_ramp, difficulty_min)


func spawn_enemy(enemy_data: EnemyData, enemy_position: Vector2) -> void:
	var enemy := ENEMY.instantiate() as Enemy
	enemy.data = enemy_data
	enemy.position = enemy_position
	enemy.died.connect(_on_enemy_died)
	enemies_marker.add_child(enemy)
	# Random offset so the whole wave doesn't shoot at once
	enemy.shot_cooldown.start(enemy.data.cooldown * difficulty + randf_range(0.0, 5.0))


func spawn_mothership() -> void:
	var enemy := ENEMY.instantiate() as Enemy
	enemy.data = MOTHERSHIP
	enemy.velocity.x = -25
	enemy.collision_mask = 1 << 3
	mothership_marker.add_child(enemy)
	enemy.died.connect(_on_enemy_died)
	enemy.shot_cooldown.start()

	var sound := AudioStreamPlayer.new()
	sound.stream = MOTHERSHIP_SOUND
	sound.autoplay = true
	sound.bus = "Sound Effects"
	sound.volume_db = -10
	enemy.add_child(sound)


func _on_movement_timer_timeout() -> void:
	if wall_was_hit:
		enemies_marker.move_local_y(ENEMY_SIZE.y * 2)
		direction *= -1
		wall_was_hit = false
	else:
		enemies_marker.move_local_x(ENEMY_SIZE.x * direction.x)
	music.play()


func _on_walls_body_entered(body: Node2D) -> void:
	if body.get_parent() == enemies_marker and body is Enemy and not wall_was_hit:
		wall_was_hit = true
		movement_timer.wait_time = maxf(movement_timer.wait_time - 0.1, 0.2)


func _on_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)
	# The dying enemy is still a child at this point
	if enemies_marker.get_child_count() < 2:
		wave_cleared.emit()
		spawn_enemies.call_deferred()
