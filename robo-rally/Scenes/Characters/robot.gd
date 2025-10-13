extends CharacterBody2D

var player: String
var character: String

var UI;

signal player_decision_end

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
var register = [null,null,null,null,null]

func decision_start():
	while cards_in_hand.size() <= 9:
		if deck <= 0:
			deck = discard
			discard.clear()
			deck.shuffle()
		cards_in_hand.append(deck.pop_front())
		
	cards_in_hand.sort()
	
func decision_end():
	for i in cards_in_hand:
		if i.Type == "Movement":
			discard.append(cards_in_hand.pop_at(i))
			
	player_decision_end.emit(player, register)
	
  
func Move(num_actions):
	pass
	
func MoveBack(num_actions):
	pass
	
func Again(num_actions):
	pass
	
func RotateRight(num_actions):
	pass
	
func RotateLeft(num_actions):
	pass
	
func Uturn(num_actions):
	pass
	
func PowerUp(num_actions):
	pass
	


func _ready() -> void:
	
	UI = get_node("res://Scenes/UI/board.tscn")
	
	player_decision_end.connect(Callable(self, "_on_all_decided"))
	
	# Create deck of cards for specific characterand set correct sprite for each
	for card in deck:
		card.character = character
		card.sprite = load("res://Graphics/CardSprites/%s_cards/%s_%s_card.png"
							 % [character.to_lower(), character.to_lower(), card.name])

	# Shuffle cards
	deck.shuffle()
