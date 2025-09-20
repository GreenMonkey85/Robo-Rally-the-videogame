extends CharacterBody2D

var player: String
var character: String

var energy = 3
var checkpoints = 0



var deck = preload("res://Resources/Cards/Movement_Cards/movement_deck.tres")
var discard = []
var cards_in_hand = []
var current_permanent_upgrades = []
var current_temporary_upgrades = []
var upgrades_in_hand = []
var register = [5]

func _ready() -> void:
	
	# Create deck of cards for specific characterand set correct sprite for each
	for card in deck.cards:
		card.character = character
		card.sprite = load("res://Graphics/CardSprites/%s_cards/%s_%s_card.png"
							 % [character.to_lower(), character.to_lower(), card.name])
	
	#Shuffle
	deck.shuffle()


	for card in deck:
		print(card.character, card.name)
