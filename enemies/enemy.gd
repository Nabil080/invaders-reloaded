class_name Enemy
extends CharacterBody2D

signal died(enemy: Enemy)

const BULLET := preload("uid://dyagxqjl3lok1")
const SHIELD := preload("uid://c4d2t5yq03sqt")
const EXPLOSION_SCENE := preload("uid://btmp75ivjghwy")

@export var data: EnemyData

var last_position := Vector2.ZERO

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shot_marker: Marker2D = $ShotMarker
@onready var shot_cooldown: Timer = $ShotCooldown


func _ready() -> void:
	animated_sprite_2d.sprite_frames = data.sprite_frames
	modulate = data.color
	shot_cooldown.wait_time = data.cooldown
	last_position = global_position
	if velocity.x != 0:
		animated_sprite_2d.play()


func _physics_process(_delta: float) -> void:
	# The wave moves in steps: show the next frame on each step
	if last_position != global_position:
		var frame_count := animated_sprite_2d.sprite_frames.get_frame_count("default")
		animated_sprite_2d.frame = (animated_sprite_2d.frame + 1) % frame_count
	move_and_slide()

	last_position = global_position
	if global_position.x < -16:
		queue_free()


func take_damage(_damage: int = 0) -> void:
	died.emit(self)
	var explosion := EXPLOSION_SCENE.instantiate() as Node2D
	explosion.global_position = global_position
	explosion.modulate = modulate
	get_tree().current_scene.add_child(explosion)
	queue_free()


func spawn_bullet() -> void:
	var bullet := BULLET.instantiate() as Bullet
	bullet.data = data.bullet_data
	bullet.global_position = shot_marker.global_position
	bullet.modulate = modulate
	get_tree().current_scene.add_child(bullet)
	shot_cooldown.start()
	$ShootSound.play()


func spawn_shield() -> void:
	var shield := SHIELD.instantiate() as Shield
	shield.position = shot_marker.position
	shield.modulate = modulate
	add_child(shield)
	tree_exited.connect(shield.queue_free, CONNECT_ONE_SHOT)

	await get_tree().create_timer(data.shield_time, false).timeout
	if is_instance_valid(shield):
		shield.queue_free()
	shot_cooldown.start()


func _on_shot_cooldown_timeout() -> void:
	if data.shield_time:
		spawn_shield()
	else:
		spawn_bullet()
