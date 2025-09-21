extends Node

var player_order = []
var damage_cards = []
var damage_discards = []
var upgrade_cards = []
var upgrade_discards = []
var registers = []
var timer = Timer.new()

func action_round():
	pass
	
func decision_round():
	for player in player_order:
		player.decision()
		

func start_game(player_list, chosen_board):
	player_order = player_list.shuffle()
	
	decision_round()
	
	
	
	
	
