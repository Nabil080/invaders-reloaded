## Held by the front row of enemies. Sends the player's bullet back down.
class_name Shield
extends StaticBody2D

@onready var block_sound: AudioStreamPlayer = $BlockSound


func _ready() -> void:
	$AnimatedSprite2D.play("default")


func block(bullet: Bullet) -> void:
	bullet.velocity.y *= -0.5
	# The bullet now acts like an enemy bullet: it hits the player and the player's bullets
	bullet.set_collision_layer_value(4, false)
	bullet.set_collision_layer_value(5, true)
	bullet.set_collision_mask_value(2, true)
	bullet.set_collision_mask_value(3, false)
	bullet.set_collision_mask_value(4, true)
	bullet.set_collision_mask_value(5, false)
	bullet.hit.emit()
	bullet.was_blocked = true
	bullet.modulate = modulate

	# Played from the scene root so the sound isn't cut when the shield goes
	var sound := block_sound.duplicate()
	get_tree().current_scene.add_child(sound)
	sound.play()
	sound.finished.connect(queue_free)
	SaveLoad.data.shots_returned += 1
