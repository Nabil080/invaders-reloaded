## One block of a bunker. Each hit shows the next, more damaged frame.
class_name BunkerPart
extends StaticBody2D

@export var sprites: SpriteFrames

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.sprite_frames = sprites
	animated_sprite_2d.frame = 0


func take_damage(damage: int) -> void:
	if animated_sprite_2d.frame + 1 >= sprites.get_frame_count("default"):
		queue_free()
	else:
		animated_sprite_2d.frame += damage
