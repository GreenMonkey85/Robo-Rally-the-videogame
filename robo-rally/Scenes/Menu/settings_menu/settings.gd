extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst = Game.TITLE_MENU.instantiate()
	print("Instance =", inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/title_menu/main_menu.tscn")
