extends Node

const TITLE_MENU = preload("res://Scenes/Menu/title_menu/main_menu.tscn")
const CHARACTER_MENU = preload("res://Scenes/Menu/character_menu/carousel_contianer.tscn")
const BOARD_MENU = preload("res://Scenes/Menu/board_menu/board_container.tscn")
const VICTORY = preload("res://Scenes/UI/victory.tscn")
const SETTINGS_MENU = preload("res://Scenes/Menu/settings_menu/settings.tscn")

const ALL_ROBOTS = ["Twonky", "HammerBot", "SpinBot"]



var ACTION_UI = null


var current_board = null
var action_ui = null
var cardSelected
var mouseOnPlacement = false
var currentPlacement = null

var player_order = []
var damage_cards = []
var damage_discards = []
var upgrade_cards = []
var upgrade_discards = []

var num_players = 3
var num_AI = 0

var players_decided = []
var registers = []

var timer = Timer.new()

signal robot_won(name)
var winner_name = ""

var reset_request = false

var pause_menu = null

signal card_display(card)

func reset():
	player_order.clear()
	registers.clear()
	players_decided.clear()
	damage_cards.clear()
	damage_discards.clear()
	upgrade_cards.clear()
	upgrade_discards.clear()
	#current_board = null
	winner_name = ""
	ACTION_UI = null
	
	for robot in get_all_robots():
		if robot != null:
			if robot.is_connected("robot_won", robot._on_robot_won):
				robot.disconnect("robot_won", robot._on_robot_won)

func get_all_robots():
	# Return a list of robot instances still in memory
	var robots = []
	for r in player_order:
		if r != null:
			robots.append(r)
	return robots

func action_round():
	# loop through each register slot
	for i in range(5):
		# loop through each player with respect to order
		for j in range(len(player_order)):
			print("HANDLE ", player_order[j].player, " ", registers, " ", i)
			# Replace 'some_card_data_instance' with actual CardData object for the current card
			var some_card_data_instance = null
			#action_ui.show_card_preview(registers[j][i])
			action_ui.visible = true
			# current player moves
			print("WHAT IS THIS ", player_order[j], " ", registers[j][i])
			#print("REGISTERS ", registers)
			emit_signal("card_display", registers[j][i])
			await player_order[j].handle_action(registers[j][i], i)
			action_ui.visible = false
			if get_tree().current_scene == VICTORY:
				# stop all moves, somebody has won
				return
			
		# double conveyers
		for robot in player_order:
			await robot.check_conveyor(2)
		# single conveyer
		for robot in player_order:
			await robot.check_conveyor(1)
		# push panels
		# WE HAVE NO PUSH PANELS
		# rotate gears
		for robot in player_order:
			await robot.gears()
		# pitfalls
		for robot in player_order:
			await robot.pitfalls()
		# board lasers
		# INCOMPLETE, MUST ADD DAMAGE FUNCTIONALITY 
		# robot lasers
		if get_tree().current_scene != VICTORY:
			for rob in player_order:
				print("Trying laser for " + str(rob))
				await rob.laser_attack()
				await get_tree().create_timer(2).timeout
		# battery
		# INCOMPLETE, MUST ADD DAMAGE FUNCTIONALITY
		for robot in player_order:
			await robot.battery()
		# check flags
		await checking_checkpoint()
		
	# after all registers done, must restore any robot that fell into a pit
	for robot in player_order:
		await robot.restore_from_pit()
	
	# end round
	for i in player_order:
		i.action_end()
	player_order.append(player_order.pop_front())
	decision_round()

func decision_round():
	for player in player_order:
		player.decision_start()
		if player.player == "Player":
			await player.player_decision_end

func on_all_decided(player, register):
	if player not in players_decided:
		players_decided.append(player)
		for i in range(len(player_order)):
			if player_order[i] == player:
				registers[i] = register
				break

	if len(players_decided) >= len(player_order):
		players_decided.clear()
		action_round()

func start_game(player_list, chosen_board):
	player_order = player_list.shuffle()
	for i in range(len(player_order)):
		registers.append(null)
	decision_round()

func wall_key(a: Vector2, b: Vector2) -> String:
	# Convert to a format like "x1,y1|x2,y2" and sort so order doesn't matter
	var A = "%s,%s" % [a.x, a.y]
	var B = "%s,%s" % [b.x, b.y]
	return A + "|" + B if a.x < b.x else B + "|" + A

func checking_checkpoint():	
	if winner_name != "":
		print("Someone's already won, no point in checking")
		return
	for robot in player_order:
		print(robot.character + " has " + str(robot.checkpoints) + " checkpoint(s)")
		var robot_pos = Vector2(robot.pos_x, robot.pos_y)
		print("Robot position: " + str(robot_pos))
		
		if robot_pos == current_board.checkpoints.keys()[robot.checkpoints] && current_board.checkpoints.keys().find(robot_pos) == robot.checkpoints:
			robot.checkpoints += 1
			current_board.checkpoints[robot_pos].play(robot.character.to_lower() + "_check_" + str(robot.checkpoints))
			
			print("Num Checkpoints on Board: " + str(len(current_board.checkpoints.keys())))
			print("Num Checkpoints reached: " + str(robot.checkpoints))
			print(robot.checkpoints == len(current_board.checkpoints.keys()))
			# Check if we have a winner
			if str(robot.checkpoints) == str(len(current_board.checkpoints.keys())):
				emit_signal("robot_won", robot.character)
				return
			else:
				await get_tree().create_timer(2).timeout
				current_board.checkpoints[robot_pos].play("idle_" + str(robot.checkpoints))

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE and current_board != null:
		pause_menu.visible = true
