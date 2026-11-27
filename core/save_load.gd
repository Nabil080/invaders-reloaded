## Loads and saves the lifetime statistics (autoload).
extends Node

const SAVE_PATH := "user://SaveFile.tres"

var data := SaveData.new()


func _ready() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		data = ResourceLoader.load(SAVE_PATH).duplicate(true)


func save() -> void:
	ResourceSaver.save(data, SAVE_PATH)


func reset() -> void:
	data = SaveData.new()
	save()


func add_game(game: SaveData) -> void:
	data.add_game(game)
	save()
