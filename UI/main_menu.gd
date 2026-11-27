extends CanvasLayer


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://core/game.tscn")


func _on_statistics_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/statistics_page.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
