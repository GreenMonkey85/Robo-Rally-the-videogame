extends Node
var player_order = []
var damage_cards = []
var damage_discards = []
var upgrade_cards = []
var upgrade_discards = []
var character_to_color = {"Twonky": "Orange",
 						  "Hammer Bot": "Purple",
						  "Spin Bot": "Blue",
 						  "Robby": "White"}

func start_game(player_list, chosen_board):
	player_order
