class_name EnemyData
extends Resource

@export var sprite_frames: SpriteFrames
@export var color: Color = Color.WHITE
@export var score: int = 10

@export_group("Weapon")
@export var bullet_data: BulletData
@export var cooldown: float = 2.5
## Enemies with a shield time hold up a shield instead of shooting.
@export var shield_time: float = 0.0
