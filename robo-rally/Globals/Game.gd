extends Node

const TITLE_MENU = preload("res://Scenes/Menu/title_menu/main_menu.tscn")
const CHARACTER_MENU = preload("res://Scenes/Menu/character_menu/carousel_contianer.tscn")
const BOARD_MENU = preload("res://Scenes/Menu/board_menu/board_container.tscn")
const VICTORY = preload("res://Scenes/UI/victory.tscn")
const SETTINGS_MENU = preload("res://Scenes/Menu/settings_menu/settings.tscn")

const ALL_ROBOTS = ["Twonky", "HammerBot"]

var current_board = null

var cardSelected
var mouseOnPlacement = false
var currentPlacement = null

var player_order = []
var damage_cards = []
var damage_discards = []
var upgrade_cards = []
var upgrade_discards = []

var players_decided = []
var registers = []

var timer = Timer.new()

var winner_name = ""

var reset_request = false

func reset():
	player_order.clear()
	registers.clear()
	players_decided.clear()
	damage_cards.clear()
	damage_discards.clear()
	upgrade_cards.clear()
	upgrade_discards.clear()
	#current_board = null
	
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
			#print("HANDLE ", player_order[j].player, " ", registers, " ", i)
			# current player moves
			print("WHAT IS THIS ", player_order[j], " ", registers[j][i])
			#print("REGISTERS ", registers)
			await player_order[j].handle_action(registers[j][i], i)
			if get_tree().current_scene == VICTORY:
				# stop all moves, somebody has won
				return
		# double conveyers
		# single conveyer
		# push panels
		# rotate gears
		# board lasers
		# robot lasers
		if get_tree().current_scene != VICTORY:
			for rob in player_order:
				#print("Trying laser for " + str(rob))
				rob.laser_attack()
				await get_tree().create_timer(2).timeout
		# battery
		# check flags
		checking_checkpoint()
		
		
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

#func draw_a_card(card_deck, card_discard):
	#if card_deck <= 0:
		#card_deck.append_array(card_discard)
		#card_discard.clear()
		#card_deck.shuffle()
	#return card_deck.pop_front()

func wall_key(a: Vector2, b: Vector2) -> String:
	# Convert to a format like "x1,y1|x2,y2" and sort so order doesn't matter
	var A = "%s,%s" % [a.x, a.y]
	var B = "%s,%s" % [b.x, b.y]
	return A + "|" + B if a.x < b.x else B + "|" + A

func checking_checkpoint():	
	for robot in player_order:
		var robot_pos = Vector2(robot.pos_x, robot.pos_y)
		#print(robot_pos)
		if robot_pos == current_board.checkpoints.keys()[robot.checkpoints]:
			robot.checkpoints += 1
			current_board.checkpoints[robot_pos].play(robot.character.to_lower() + "_check_" + str(robot.checkpoints))
