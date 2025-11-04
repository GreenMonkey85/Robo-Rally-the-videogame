extends Node

var board

func _ready():
	board = preload("res://Scenes/Boards/castle_tour_board.tscn").instantiate()
	for robot in Game.player_order:
		$Players.add_child(robot)
		
	$Map.add_child(board)
	
	Game.player_order.shuffle()
	
	for i in range(len(Game.player_order)):
		Game.registers.append(null)
	Game.decision_round()
	
