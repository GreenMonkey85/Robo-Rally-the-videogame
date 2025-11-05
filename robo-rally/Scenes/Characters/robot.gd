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



# TESTING 
#@onready var robot_x = 0
#@onready var robot_y = 0
#@onready var robot_direction = "bl"
#@onready var robot_shutdown = false
#
#@onready var robot_animationPlayer : AnimationPlayer = $Sprite2D/AnimationPlayer

#@onready var robot : CharacterBody2D = $"." Use self.___() or ___()
#@onready var p1cam : Camera2D = $P1Camera



# moves the robot on the board, uses the arrow keys
#func move_robot(x, y) -> Vector2:
	#robot_x = x
	#var robot_pixel_x = x * (852 / 2)
	#robot_y = y 
	#var robot_pixel_y = y * (426 / 2)
	#return Vector2(robot_pixel_x, robot_pixel_y)
#
#func handle_card(dir):
	#if dir == 'tl' && Vector2(robot_x, robot_y) not in get_parent().walls['tl']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x - 1, robot_y - 1), 1)
	#elif dir == 'br' && Vector2(robot_x, robot_y) not in get_parent().walls['br']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x + 1, robot_y + 1), 1)
	#elif dir == 'tr' && Vector2(robot_x, robot_y) not in get_parent().walls['tr']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x + 1, robot_y - 1), 1)
	#elif dir == 'bl' && Vector2(robot_x, robot_y) not in get_parent().walls['bl']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x - 1, robot_y + 1), 1)
	
# END TESTING



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
		
	player_decision_end.connect(Callable(self, "_on_all_decided"))
	
	# Create deck of cards for specific characterand set correct sprite for each
	for card in deck:
		
		card.character = character
		card.sprite = load("res://Graphics/CardSprites/%s_cards/%s_%s_card.png"
							 % [character.to_lower(), character.to_lower(), card.name])

	# Shuffle cards
	deck.shuffle()
	
	# TESTING
	#position = move_robot(robot_x, robot_y)
	#change_idle()
	# END TESTING


# TESTING
#func change_idle() -> void:
	#robot_animationPlayer.play(robot_direction + "_idle")

# shuts down the robot: inputs will not work while shut down
#func shutdown() -> void:
	#if robot_shutdown:
		#change_idle()
		#robot_shutdown = false
	#else:
		#robot_animationPlayer.play(robot_direction + "_shutdown")
		#robot_shutdown = true

# uses current direction of robot and turn input to turn in the correct direction
#func turn_hammer(dir) -> void:
	#if dir == 'left':
		#match robot_direction:
			#'bl':
				#robot_direction = 'br'
			#'br':
				#robot_direction = 'tr'
			#'tr':
				#robot_direction = 'tl'
			#'tl':
				#robot_direction = 'bl'
			#_:
				#print('BAD DIRECTION, NOT REAL')
	#else:
		#match robot_direction:
			#'bl':
				#robot_direction = 'tl'
			#'tl':
				#robot_direction = 'tr'
			#'tr':
				#robot_direction = 'br'
			#'br':
				#robot_direction = 'bl'
			#_:
				#print('BAD DIRECTION, NOT REAL')
	## restores idle
	#change_idle()

#func _unhandled_input(event: InputEvent) -> void:
	# For moving forward or backward from a card, can find the direction the robot
	# is facing and do that movement. movement side to side is included for the 
	# sake of the conveyor belts and pushing. My suggestion would be to have the 
	# robot moving into the space triggers the robot already moving to move out of 
	# the way, and if theres a wall blocking them then they never move at all.
	
	#print("start on: " + str(robot_x) + ", " + str(robot_y))
	# check if shutdown, if so then no input will work except to exit shutdown
	#if robot_shutdown:
		#if event.is_action_pressed("ui-shutdown"):
			#shutdown()
		#return
		#
	## MOVEMENT
	#if event.is_action_pressed("ui_up") && Vector2(robot_x, robot_y) not in get_parent().walls['tl']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x - 1, robot_y - 1), 1)
	#elif event.is_action_pressed("ui_down") && Vector2(robot_x, robot_y) not in get_parent().walls['br']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x + 1, robot_y + 1), 1)
	#elif event.is_action_pressed("ui_right") && Vector2(robot_x, robot_y) not in get_parent().walls['tr']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x + 1, robot_y - 1), 1)
	#elif event.is_action_pressed("ui_left") && Vector2(robot_x, robot_y) not in get_parent().walls['bl']:
		#var robot_tween = create_tween()
		#robot_tween.tween_property(self, "position", move_robot(robot_x - 1, robot_y + 1), 1)	
		#
	#get_parent().checking_checkpoint()
		#
	## TURNING
	#if event.is_action_pressed("ui-turn-left"):
		#turn_hammer('left')
	#elif event.is_action_pressed("ui-turn-right"):
		#turn_hammer('right')
		#
	## SHUTDOWN
	#elif event.is_action_pressed("ui-shutdown"):
		#shutdown()
		#
	## FIRE LASER To be added
	##elif event.is_action_pressed("ui-laser"):
		##hammer_animationPlayer.play(hammer_direction + "_laser")
	#print("now on: " + str(robot_x) + ", " + str(robot_y))


# END TESTING
