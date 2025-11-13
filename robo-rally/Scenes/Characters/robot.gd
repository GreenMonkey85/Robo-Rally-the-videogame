extends CharacterBody2D

const PIXEL_X = 852 / 2
const PIXEL_Y = 426 / 2


var player: String
var character: String
var anim_player: AnimationPlayer

var pos_x = 0
var pos_y = 0

var direction = "bl"
var x_dir_mult = -1
var y_dir_mult = 1

signal player_decision_end

var energy = 3
var checkpoints = 0

var deck = [preload("res://Resources/Cards/Movement_Cards/move1.tres"), preload("res://Resources/Cards/Movement_Cards/move1.tres"),
			preload("res://Resources/Cards/Movement_Cards/move1.tres"), preload("res://Resources/Cards/Movement_Cards/move1.tres"),
			preload("res://Resources/Cards/Movement_Cards/rotate_left.tres"), preload("res://Resources/Cards/Movement_Cards/rotate_left.tres"),
			preload("res://Resources/Cards/Movement_Cards/rotate_left.tres"), preload("res://Resources/Cards/Movement_Cards/rotate_left.tres"),
			preload("res://Resources/Cards/Movement_Cards/rotate_right.tres"), preload("res://Resources/Cards/Movement_Cards/rotate_right.tres"),
			preload("res://Resources/Cards/Movement_Cards/rotate_right.tres"), preload("res://Resources/Cards/Movement_Cards/rotate_right.tres"),
			preload("res://Resources/Cards/Movement_Cards/move2.tres"), preload("res://Resources/Cards/Movement_Cards/move2.tres"),
			preload("res://Resources/Cards/Movement_Cards/move2.tres"), preload("res://Resources/Cards/Movement_Cards/again.tres"),
			preload("res://Resources/Cards/Movement_Cards/move_back.tres"), preload("res://Resources/Cards/Movement_Cards/uturn.tres"),
			preload("res://Resources/Cards/Movement_Cards/move3.tres"), preload("res://Resources/Cards/Movement_Cards/power_up.tres")]

var discard = []
var cards_in_hand = []
var current_permanent_upgrades = []
var current_temporary_upgrades = []
var upgrades_in_hand = []
var register = [null,null,null,null,null]

var last_move = "Spam"

func decision_start():
	while cards_in_hand.size() < 9:
		if len(deck) <= 0:
			deck = discard
			discard.clear()
			deck.shuffle()
		var new_card = deck.pop_front()
		cards_in_hand.append(new_card)
		$UI.draw_animation(new_card)
		
		
	cards_in_hand.sort()

func decision_end():
	var register_list = $UI/UI/Register.get_children()
	register_list.pop_front()

	for i in range(len(register_list)):
		if register_list[i].placed_card != null:
			register[i] = register_list[i].placed_card.cardData
			cards_in_hand.erase(register[i])
	for i in range(cards_in_hand.size() -1, -1, -1):
		if cards_in_hand[i].type == "Movement":
			discard.append(cards_in_hand.pop_at(i))
	
	Game.on_all_decided(self, register)

func handle_action(card: CardData, register_index):
	# Show preview at top-left
	$UI.show_card_preview(card)
	
	if card.type == "Movement":
		await call(card.action, card.num_action)
	elif card.type == "Damage":
		await call(card.action, card.num_action, register_index)
	last_move = card.action

func Move(num_actions):
	for i in range(num_actions):
		pos_x +=  x_dir_mult
		pos_y +=  y_dir_mult
		var new_pos = create_tween()
		new_pos.tween_property(self, "position", Vector2(pos_x * PIXEL_X, pos_y * PIXEL_Y), 1)
		anim_player.play(direction + "_walk")
		await new_pos.finished
		anim_player.play(direction + "_idle")

func Again(num_actions):
	call(last_move, num_actions)

func Rotate(num_actions):
	if num_actions == 0:
		match direction:
					'bl':
						direction = 'tr'
					'tl':
						direction = 'br'
					'tr':
						direction = 'bl'
					'br':
						direction = 'tl'
					_:
						print('BAD DIRECTION, NOT REAL')
	else:
		for i in range(abs(num_actions)):
			# Rotate Right
			if num_actions > 0:
				match direction:
					'bl':
						direction = 'tl'
					'tl':
						direction = 'tr'
					'tr':
						direction = 'br'
					'br':
						direction = 'bl'
					_:
						print('BAD DIRECTION, NOT REAL')
			# Rotate Left
			elif num_actions < 0:
				match direction:
					'bl':
						direction = 'br'
					'br':
						direction = 'tr'
					'tr':
						direction = 'tl'
					'tl':
						direction = 'bl'
					_:
						print('BAD DIRECTION, NOT REAL')
	change_xy_dir()
	anim_player.play(direction + "_idle")

func PowerUp(num_actions):
	energy += num_actions

func Spam(num_actions, register_index):
	var card = Game.draw_a_card(deck, discard)
	register[register_index] = card
	call(card, num_actions)
	

func change_xy_dir():
	match direction:
		"bl":
			x_dir_mult = -1
			y_dir_mult = 1
		"br":
			x_dir_mult = 1
			y_dir_mult = 1
		"tl":
			x_dir_mult = -1
			y_dir_mult = -1
		"tr":
			x_dir_mult = 1
			y_dir_mult = -1
			
func set_character(character):
	self.character = character
	for card: CardData in deck:
		card.character = character
		card.sprite = load("res://Graphics/CardSprites/%s_cards/%s_%s_card.png"
							 % [character.to_lower(), character.to_lower(), card.name])
	var sprite = load("res://Scenes/Characters/%s.tscn" % [character]).instantiate()
	anim_player = sprite.get_node("AnimationPlayer")
	add_child(sprite)

func _ready() -> void:
	# Shuffle cards
	deck.shuffle() 
