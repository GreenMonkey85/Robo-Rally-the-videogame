extends Node

var board

func _ready():
	board = preload("res://Scenes/Boards/castle_tour_board.tscn").instantiate()
	for robot in Game.player_order:
		board.add_child(robot)
		
	add_child(board)
	
