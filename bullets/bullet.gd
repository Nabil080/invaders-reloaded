class_name Bullet
extends CharacterBody2D

## Emitted when the bullet hits something, unless a shield sent it back.
signal hit

const EXPLOSION_SCENE := preload("uid://btmp75ivjghwy")

@export var data: BulletData

var was_blocked := false
var hit_by_bullet := false


func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = data.sprite_frames
	$AnimatedSprite2D.play("default")
	velocity = data.direction * data.speed
	safe_margin = 0.0
	collision_layer = data.layer
	collision_mask = data.mask
	# The shape resource is shared between all bullets
	var shape := ($CollisionShape2D.shape as RectangleShape2D).duplicate()
	shape.size = data.size
	$CollisionShape2D.shape = shape


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision.get_collider())


func take_damage(_damage: int) -> void:
	if not was_blocked:
		hit.emit()
	if hit_by_bullet:
		var explosion := EXPLOSION_SCENE.instantiate() as Node2D
		explosion.global_position = global_position
		explosion.modulate = modulate
		get_tree().current_scene.add_child(explosion)
	queue_free()


func _on_collision(collider: Object) -> void:
	if collider is Bullet:
		collider.hit_by_bullet = true
		hit_by_bullet = true
		SaveLoad.data.shots_clashed += 1
	# Layer 4 is the player's bullets
	if collider is BunkerPart and get_collision_layer_value(4):
		SaveLoad.data.shots_bunker += 1
	if collider.has_method("take_damage"):
		collider.take_damage(data.damage)
	if collider.has_method("block"):
		collider.block(self)
	else:
		take_damage(data.damage)
