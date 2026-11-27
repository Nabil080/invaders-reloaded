class_name BulletData
extends Resource

@export var damage: int = 1
@export var speed: float = 200.0
@export var sprite_frames: SpriteFrames
@export var direction: Vector2 = Vector2.DOWN
@export var size: Vector2 = Vector2(1.0, 5.0)
@export_flags_2d_physics var layer: int
@export_flags_2d_physics var mask: int
