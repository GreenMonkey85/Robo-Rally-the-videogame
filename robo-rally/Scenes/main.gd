extends Node

func _ready():
	var starting_positions = Game.current_board.STARTING_POSITIONS.duplicate()
	starting_positions.shuffle()
	Game.pause_menu = $UI/PauseMenu.get_children()[0]
	Game.pause_menu.visible = false
	Game.action_ui = $UI/ActionUI.get_children()[0]
	Game.action_ui.visible = false
	$Map.add_child(Game.current_board)
	
	for robot: Node2D in Game.player_order:
		$Players.add_child(robot)
		var starting_position: Vector2 = starting_positions.pop_front()
		robot.pos_x = starting_position.x
		robot.pos_y = starting_position.y
		robot.position = Game.current_board.ORIGIN + (starting_position * Vector2(Game.current_board.PIXEL_X,
													 Game.current_board.PIXEL_Y))
		print(robot.pos_x, robot.pos_y)
		#robot.scale = Vector2(1.3,1.3)
		
	
	Game.player_order.shuffle()
	
	for i in range(len(Game.player_order)):
		Game.registers.append(null)
	
	Game.connect("robot_won", Callable(self, "_on_robot_won"))		
	Game.connect("card_display", Callable($UI/ActionUI, "_on_card_display"))
	Game.connect("checkpoints_reached", Callable($UI/ActionUI, "_on_checkpoints_reached"))
	var connections = Game.get_signal_connection_list("card_display")
	print("Connections for 'card_display':")
	for conn in connections:
		print("SIGNAL" + str(conn['signal']))
		print("CALLABLE" + str(conn['callable']))
		
	Game.ACTION_UI = $UI/ActionUI
	print(Game.ACTION_UI, Game.ACTION_UI.get_script())

	Game.decision_round()
	#Game.start_game(Game.player_order, Game.current_board)
	
	

func _on_robot_won(name):
	Game.winner_name = name
	print(name + " wins")
	
	for child in $Players.get_children():
		#$Players.remove_child(child)
		child.queue_free()
	
	for child in $Map.get_children():
		child.queue_free()
	
	Game.reset_request = true
	
	call_deferred("_go_to_victory")

func _go_to_victory():
	print("Game.VICTORY =", Game.VICTORY)
	get_tree().change_scene_to_packed(Game.VICTORY)
