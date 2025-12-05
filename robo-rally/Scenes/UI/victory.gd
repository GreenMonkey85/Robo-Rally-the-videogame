extends Node2D

@onready var victoryMessage = $Panel/victory
@onready var returnButton = $Panel/main
@onready var show_winner = $Panel/WinnerSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Game.winner_name == "Twonky":
		# Twonky Color
		victoryMessage.add_theme_color_override("font_color", "#f88d00")
		returnButton.add_theme_color_override("font_color", "#f88d00")
	elif Game.winner_name == "HammerBot":
		#HammerBot Color
		victoryMessage.add_theme_color_override("font_color", "#6f3198")
		returnButton.add_theme_color_override("font_color", "#6f3198")
	elif Game.winner_name == "SpinBot":
		# SpinBot Color
		victoryMessage.add_theme_color_override("font_color", "#2f3699")
		returnButton.add_theme_color_override("font_color", "#2f3699")
	elif Game.winner_name == "Robby":
		# Robby Color
		victoryMessage.add_theme_color_override("font_color", "#b4b4b4")
		returnButton.add_theme_color_override("font_color", "#b4b4b4")
	
	var sprite_path = "res://Scenes/Characters/%s.tscn" % Game.winner_name
	var char_scene = load(sprite_path)
	
	if char_scene == null:
		print("Error: Could not load", sprite_path)
		return
	
	for child in show_winner.get_children():
		show_winner.remove_child(child)
	
	var char_instance = char_scene.instantiate()
	show_winner.add_child(char_instance)
	char_instance.scale = Vector2(0.5,0.5)
	# show_winner.pos = Vector2(0,75)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_pressed() -> void:
	print('pressed main menu button!')
	for child in show_winner.get_children():
		show_winner.remove_child(child)
	#Game.reset()
	get_tree().change_scene_to_packed(Game.TITLE_MENU)
