extends Control

func _on_play_pressed() -> void:
	if Game.reset_request:
		Game.reset()
	get_tree().change_scene_to_packed(Game.CHARACTER_MENU)

func _on_quit_pressed() -> void:
	get_tree().quit()
