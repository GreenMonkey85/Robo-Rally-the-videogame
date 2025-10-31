extends Node

const TITLE_MENU = preload("res://Scenes/Menu/title_menu/main_menu.tscn")
const CHARACTER_MENU = preload("res://Scenes/Menu/character_menu/carousel_contianer.tscn")
const BOARD_MENU = preload("res://Scenes/Menu/board_menu/board_container.tscn")



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

func action_round():
	# loop through each register slot
	for i in range(len(registers[0])):
		# loop through each player with respect to order
		for j in range(len(player_order)):
			# current player moves
			player_order[j].handle_action(registers[j][i], )
		# double conveyers
		# single conveyer
		# push panels
		# rotate gears
		# board lasers
		# robot lasers
		# battery
		# check flags
	decision_round()

func decision_round():
	for player in player_order:
		player.decision()
	timer.start(60.0)

func _on_all_decided(player, register):
	
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
	
func draw_a_card(card_deck, card_discard):
	if card_deck <= 0:
		card_deck.append_array(card_discard)
		card_discard.clear()
		card_deck.shuffle()
	return card_deck.pop_front()
