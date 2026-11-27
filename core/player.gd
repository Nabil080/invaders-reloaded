class_name Player
extends CharacterBody2D

signal player_shot
signal death_started
signal death_ended

const BULLET := preload("uid://dyagxqjl3lok1")
const MAX_SPEED := 150.0
const ACCEL := 1400.0
const FRICTION := 1800.0
const BULLET_COLOR := Color("#63c74d")

@export var bullet_data: BulletData = preload("uid://hk41ik0cwpuf")

var start_position: Vector2
var dying := false
var can_shoot := true

@onready var shot_marker: Marker2D = $ShotMarker
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var blink_animation: AnimationPlayer = $BlinkAnimation


func _ready() -> void:
	start_position = position


func _physics_process(delta: float) -> void:
	if dying:
		return
	if can_shoot and Input.is_action_pressed("shoot"):
		shoot()

	var input_dir := Input.get_axis("player_left", "player_right")
	if input_dir:
		velocity.x = move_toward(velocity.x, input_dir * MAX_SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()


func reset() -> void:
	position = start_position
	velocity = Vector2.ZERO


# One bullet on screen at a time: shooting again waits for it to hit something
func shoot() -> void:
	var bullet := BULLET.instantiate() as Bullet
	bullet.data = bullet_data
	bullet.global_position = shot_marker.global_position
	bullet.modulate = BULLET_COLOR if modulate == Color.WHITE else modulate
	get_tree().current_scene.add_child(bullet)
	bullet.hit.connect(_on_bullet_hit)

	can_shoot = false
	animated_sprite_2d.frame = 1
	shoot_sound.play()
	blink_animation.stop()
	player_shot.emit()


func take_damage(_damage: int) -> void:
	if dying or blink_animation.is_playing():
		return
	dying = true
	death_started.emit()
	animated_sprite_2d.play("death")
	$DeathSound.play()

	await get_tree().create_timer(1).timeout
	dying = false
	death_ended.emit()
	if not get_tree().paused:
		animated_sprite_2d.animation = "default"
		animated_sprite_2d.stop()


func make_invulnerable(time: float = 1.0) -> void:
	blink_animation.play("blink")
	await get_tree().create_timer(time).timeout
	blink_animation.stop()


func _on_bullet_hit() -> void:
	can_shoot = true
	animated_sprite_2d.frame = 0
