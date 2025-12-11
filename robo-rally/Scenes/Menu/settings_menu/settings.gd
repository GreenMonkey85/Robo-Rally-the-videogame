extends Node2D

@onready var num_players = $Node2D/NumPlayers
@onready var num_AI = $Node2D/NumAI
@onready var error = $Node2D/Error


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var inst = Game.TITLE_MENU.instantiate()
	#print("Instance =", inst)
	num_players.selected = num_players.get_item_id(Game.num_players - 2)
	num_AI.selected = num_AI.get_item_id(Game.num_AI)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	
	if num_players.get_item_text(num_players.selected) <= num_AI.get_item_text(num_AI.selected):
		print("must have at least one human player")
		error.visible = true
	else:
		error.visible = false
		Game.num_players = int(num_players.get_item_text(num_players.selected))
		Game.num_AI = int(num_AI.get_item_text(num_AI.selected))
		print("NUM PLAYERS: " + num_players.get_item_text(num_players.selected))
		print("NUM AI: " + num_AI.get_item_text(num_AI.selected))
	
		get_tree().change_scene_to_file("res://Scenes/Menu/title_menu/main_menu.tscn")
