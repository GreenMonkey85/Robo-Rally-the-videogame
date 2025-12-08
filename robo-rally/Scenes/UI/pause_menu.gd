extends Control

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_pressed():
	Game.pause_menu.visible = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/title_menu/main_menu.tscn")
