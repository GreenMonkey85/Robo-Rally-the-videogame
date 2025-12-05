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
	
	Game.connect("robot_won", Callable(self, "_on_robot_won"))
		##robot.connect("robot_won", Callable(self, "_on_robot_won"))
		#print("added signal to " + robot.character)
		#var result = robot.connect("robot_won", Callable(self, "_on_robot_won"))
		#print("Connect result =", result)
	Game.decision_round()
	#Game.start_game(Game.player_order, Game.current_board)
	
	

func _on_robot_won(name):
	Game.winner_name = name
	print(name + " wins")
	
	for child in $Players.get_children():
		#$Players.remove_child(child)
		child.queue_free()
	#Game.player_order.clear()
	for child in $Map.get_children():
		#$Map.remove_child(child)
		child.queue_free()
	#Game.current_board = null
	#
	#Game.registers.clear()
	
	Game.reset_request = true
	
	call_deferred("_go_to_victory")

func _go_to_victory():
	print("Game.VICTORY =", Game.VICTORY)
	get_tree().change_scene_to_packed(Game.VICTORY)
