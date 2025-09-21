extends CharacterBody2D

var player: String
var character: String

var energy = 3
var checkpoints = 0


var deck = ["res://Resources/Cards/Movement_Cards/move1.tres", "res://Resources/Cards/Movement_Cards/move1.tres",
			"res://Resources/Cards/Movement_Cards/move1.tres", "res://Resources/Cards/Movement_Cards/move1.tres",
			"res://Resources/Cards/Movement_Cards/rotate_left.tres", "res://Resources/Cards/Movement_Cards/rotate_left.tres",
			"res://Resources/Cards/Movement_Cards/rotate_left.tres", "res://Resources/Cards/Movement_Cards/rotate_left.tres",
			"res://Resources/Cards/Movement_Cards/rotate_right.tres", "res://Resources/Cards/Movement_Cards/rotate_right.tres",
			"res://Resources/Cards/Movement_Cards/rotate_right.tres", "res://Resources/Cards/Movement_Cards/rotate_right.tres",
			"res://Resources/Cards/Movement_Cards/move2.tres", "res://Resources/Cards/Movement_Cards/move2.tres",
			"res://Resources/Cards/Movement_Cards/move2.tres", "res://Resources/Cards/Movement_Cards/again.tres",
			"res://Resources/Cards/Movement_Cards/move_back.tres", "res://Resources/Cards/Movement_Cards/uturn.tres",
			"res://Resources/Cards/Movement_Cards/move3.tres", "res://Resources/Cards/Movement_Cards/power_up.tres"]

var discard = []
var cards_in_hand = []
var current_permanent_upgrades = []
var current_temporary_upgrades = []
var upgrades_in_hand = []
var register = []

func decision():
	pass

func _ready() -> void:
	
	# Create deck of cards for specific characterand set correct sprite for each
	for card in deck:
		card.character = character
		card.sprite = load("res://Graphics/CardSprites/%s_cards/%s_%s_card.png"
							 % [character.to_lower(), character.to_lower(), card.name])

	#Shuffle
	deck.shuffle()

	for card in deck.cards:
		print(card.character, card.name)
