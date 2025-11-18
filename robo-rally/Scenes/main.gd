extends Node

func _ready():
	var starting_positions = Game.current_board.STARTING_POSITIONS.duplicate()
	starting_positions.shuffle()

	for robot: Node2D in Game.player_order:
		$Players.add_child(robot)
		var starting_position: Vector2 = starting_positions.pop_front()
		robot.pos_x = starting_position.x
		robot.pos_y = starting_position.y
		robot.position = Game.current_board.ORIGIN + (starting_position * Vector2(Game.current_board.PIXEL_X,
													 Game.current_board.PIXEL_Y))
		print(robot.pos_x, robot.pos_y)
		#robot.scale = Vector2(1.3,1.3)
		
	$Map.add_child(Game.current_board)
	
	Game.player_order.shuffle()
	
	for i in range(len(Game.player_order)):
		Game.registers.append(null)
	Game.decision_round()
	
