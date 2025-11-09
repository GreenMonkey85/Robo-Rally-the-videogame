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

var deck = [preload("res://Resources/Cards/Movement_Cards/move1.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/move1.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/move1.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/move1.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/rotate_left.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/rotate_left.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/rotate_left.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/rotate_left.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/rotate_right.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/rotate_right.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/rotate_right.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/rotate_right.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/move2.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/move2.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/move2.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/again.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/move_back.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/uturn.tres").duplicate(),
			preload("res://Resources/Cards/Movement_Cards/move3.tres").duplicate(), preload("res://Resources/Cards/Movement_Cards/power_up.tres").duplicate()]

var discard = []
var cards_in_hand = []
var current_permanent_upgrades = []
var current_temporary_upgrades = []
var upgrades_in_hand = []
var register = [null,null,null,null,null]

var last_move = "Spam"

func decision_start():
	while cards_in_hand.size() < 9:
		if deck.size() <= 0:
			deck = discard.duplicate()
			discard.clear()
			deck.shuffle()
		var new_card = deck.pop_front()
		cards_in_hand.append(new_card)
		#$UI.draw_animation(new_card)
		print("DECISION START", len(deck), len(discard), len(cards_in_hand))
	print("DECISION START", deck, discard, cards_in_hand)
		
	
	#print(deck, discard, cards_in_hand)

func decision_end():
	var register_list = $UI/CanvasLayer/Register.get_children()
	register_list.pop_front()

	for i in range(len(register_list)):
		if register_list[i].placed_card != null:
			register[i] = register_list[i].placed_card.cardData
			cards_in_hand.erase(register[i])
		print("REGISTER LIST", deck, discard, cards_in_hand)
	for i in range(cards_in_hand.size() - 1, -1, -1):
		var card = cards_in_hand[i]
		if card.type == "Movement":
			self.discard.append(card)
			cards_in_hand.remove_at(i)
		print("CARDS IN HAND", deck, discard, cards_in_hand)
	
	Game.on_all_decided(self, register)

func handle_action(card: CardData, register_index):
	if card != null:
		if card.type == "Movement":
			await call(card.action, card.num_action)
		elif card.type == "Damage":
			await call(card.action, register_index)
		last_move = card.action
	else:
		await call("Spam", register_index)
		last_move = "Spam"
	

func action_end():
	for i in range(len(register)):
		discard.append(register[i])
		register[i] = null
		print("ACTION END", deck, discard, cards_in_hand)

func Move(num_actions):
	for i in range(abs(num_actions)):
		if num_actions < 0:
			pos_x -=  x_dir_mult
			pos_y -=  y_dir_mult
		else:
			pos_x +=  x_dir_mult
			pos_y +=  y_dir_mult
		var new_pos = create_tween()
		new_pos.tween_property(self, "position", Vector2(pos_x * Game.current_board.PIXEL_X,
														 pos_y * Game.current_board.PIXEL_Y)
														+ Game.current_board.ORIGIN, 1)
		anim_player.play(direction + "_walk")
		await new_pos.finished
		anim_player.play(direction + "_idle")

func Again(num_actions):
	await call(last_move, num_actions)

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

func Spam(register_index):
	if len(deck) <= 0:
		deck = discard.duplicate()
		discard.clear()
		deck.shuffle()
	var card = deck.pop_front()
	if register[register_index] != null:
		Game.damage_discards.append(register[register_index])
	register[register_index] = card
	await call(card.action, card.num_action)


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
	#print(deck)
	deck.shuffle() 
