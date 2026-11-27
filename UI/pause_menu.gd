extends CanvasLayer

signal color_changed(color: Color)

var master_bus_index := AudioServer.get_bus_index("Master")

@onready var color_slider: HSlider = $Panel/HBoxContainer/VBoxContainer2/ColorSlider
@onready var volume_slider: HSlider = $Panel/HBoxContainer/VBoxContainer2/VolumeSlider


func _ready() -> void:
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			_resume()
		else:
			_pause()


func _pause() -> void:
	get_tree().paused = true
	show()


func _resume() -> void:
	get_tree().paused = false
	hide()


func _on_continue_pressed() -> void:
	_resume()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


# 0 on the slider gives back the default white
func _on_color_slider_value_changed(value: float) -> void:
	var color := Color.from_hsv(value, 1.0, 1.0) if value else Color.WHITE
	color_slider.modulate = color
	color_changed.emit(color)
