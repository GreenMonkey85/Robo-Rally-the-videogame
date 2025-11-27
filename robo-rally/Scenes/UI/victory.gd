extends Node2D

@onready var show_winner = $Panel/WinnerSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite_path = "res://Scenes/Characters/%s.tscn" % Game.winner_name
	var char_scene = load(sprite_path)
	
	if char_scene == null:
		print("Error: Could not load", sprite_path)
		return
	
	for child in show_winner.get_children():
		show_winner.remove_child(child)
	
	var char_instance = char_scene.instantiate()
	show_winner.add_child(char_instance)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_pressed() -> void:
	print('pressed main menu button!')
	for child in show_winner.get_children():
		show_winner.remove_child(child)
	#Game.reset()
	get_tree().change_scene_to_packed(Game.TITLE_MENU)
