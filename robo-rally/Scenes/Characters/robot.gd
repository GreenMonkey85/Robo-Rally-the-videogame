extends CharacterBody2D

const PIXEL_X = 852 / 2
const PIXEL_Y = 426 / 2

var player: String = "Player"
var character: String
var anim_player: AnimationPlayer

var pos_x = 0
var pos_y = 0

var direction = "bl"
var x_dir_mult = -1
var y_dir_mult = 1

signal player_decision_end

signal robot_won(name)

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

var last_move = null

@onready var boardScript = null



signal robot_spawned(robot)

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
		if deck.size() <= 0:
			deck = discard.duplicate()
			discard.clear()
			deck.shuffle()
		var new_card = deck.pop_front()
		cards_in_hand.append(new_card)
		if player == "Player":
			$UI.draw_animation(new_card)
		print("DECISION START", len(deck), len(discard), len(cards_in_hand))
	if player == "Player":
		$UI/CanvasLayer.visible = true
		$UI._confirming = false
	else:
		var AI_register = AI.call(player, Vector2(pos_x,pos_y), Game.current_board.checkpoints.keys()[checkpoints],
			cards_in_hand, direction)
		decision_end(AI_register)
		
	
	#print(deck, discard, cards_in_hand)

func decision_end(register_list):
	$UI/CanvasLayer.visible = false
	
	for i in range(len(register_list)):
		if register_list[i] != null:
			register[i] = register_list[i]
			cards_in_hand.erase(register[i])
		print("REGISTER LIST", len(deck), len(discard), len(cards_in_hand))
	for i in range(cards_in_hand.size() - 1, -1, -1):
		var card = cards_in_hand[i]
		if card.type == "Movement":
			self.discard.append(card)
			cards_in_hand.remove_at(i)
		print("CARDS IN HAND", len(deck), len(discard), len(cards_in_hand))
	
	Game.on_all_decided(self, register)
	player_decision_end.emit()

func handle_action(card: CardData, register_index):
	# Show preview at top-left
	if card != null:
		if card.type == "Movement":
			await call(card.action, card.num_action)
		elif card.type == "Damage":
			await call(card.action, register_index)
		last_move = card
	else:
		await call("Spam", register_index)
		last_move = preload("res://Resources/Cards/Damage_Cards/spam.tres")
	print("CHECKPOINTS: ", checkpoints)

func action_end():
	for i in range(len(register)):
		if register[i] != null:
			discard.append(register[i])
		register[i] = null
		print("ACTION END", len(deck), len(discard), len(cards_in_hand))
	last_move = null

func can_move(x1, y1, x2, y2):
	# check if wall is in the way
	if Game.current_board.walls.has(Game.wall_key(Vector2(x1,y1),Vector2(x2,y2))):
		return false
	# check for players in front of new spot
	for i in Game.player_order:
		# if player in new spot and player isnt self
		if Vector2(i.pos_x, i.pos_y) == Vector2(x2, y2) and i != self:
			var new_x = i.pos_x + (x2-x1)
			var new_y = i.pos_y + (y2-y1)
			# check if this iteration's robot can move
			if not i.can_move(i.pos_x, i.pos_y, new_x, new_y):
				return false
			i.pos_x = new_x
			i.pos_y = new_y
			create_tween().tween_property(i, "position", Vector2(new_x * Game.current_board.PIXEL_X,
														 new_y * Game.current_board.PIXEL_Y)
														 + Game.current_board.ORIGIN, 1)
	return true


func Move(num_actions):
	print(character)
	print("Robot at: " + str(pos_x) + "," + str(pos_y))
	var new_x
	var new_y
	for i in range(abs(num_actions)):
		if num_actions < 0:
			new_x = pos_x - x_dir_mult
			new_y = pos_y - y_dir_mult
		else:
			new_x = pos_x + x_dir_mult
			new_y = pos_y + y_dir_mult
			
		if can_move(pos_x, pos_y, new_x, new_y):
			var new_pos = create_tween()
			new_pos.tween_property(self, "position", Vector2(new_x * Game.current_board.PIXEL_X,
															 new_y * Game.current_board.PIXEL_Y)
															 + Game.current_board.ORIGIN, 1)
			anim_player.play(direction + "_walk")
			await new_pos.finished
			anim_player.play(direction + "_idle")
			pos_x = new_x
			pos_y = new_y

func Again(num_actions):
	if last_move != null:
		await call(last_move.action, last_move.num_action)
	else:
		await call("Spam", num_actions)

func Rotate(num_actions):
	await get_tree().create_timer(0.5).timeout
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
	await get_tree().create_timer(0.5).timeout

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

func check_next_for_laser(x, y):
	if direction == 'bl':
		x -= 1
		y += 1
	elif direction == 'br':
		x += 1
		y += 1
	elif direction == 'tl':
		x -= 1
		y -= 1
	else:
		x += 1
		y -= 1
	
	return Vector2(x, y)

func laser_attack():
	# start at current player space
	var check = Vector2(pos_x, pos_y)
	var check_x = pos_x
	var check_y = pos_y
	
	# some kind of loop (for 20 spaces maybe, so that it wont check forever since edges of map arent walls yet)
	for i in range(20):
		# check if wall at current space
		var check_next = check_next_for_laser(check_x, check_y)
		
		for wall in boardScript.walls:
			#if wall.contains(str(check[0]) + ',' + str(check[1])) && wall.contains(str(check_next[0]) + ',' + str(check_next[1])):
				# if so then break loop, laser never fires
			if wall == Game.wall_key(check, check_next):
				print("Wall detected, will not fire laser")
				return
		
		# if not then count one space forward
		check = check_next
		check_x = check[0]
		check_y = check[1]
		#laser_path.append(Vector2(check_x, check_y))
		
		# now check if theres another player there
		for rob in Game.player_order:
			# if so then will fire laser
			if rob.pos_x == check_x && rob.pos_y == check_y:
				# trigger player animation for firing laser in that direction
				print("Target locked, firing laser!")
				anim_player.play(direction + "_laser")
				await get_tree().create_timer(2).timeout
				# and create Line2D (or Sprite 2D) for the laser itself
				var pixel_laser_nodes = []
				pixel_laser_nodes.append(tile_to_pixel(pos_x, pos_y))
				pixel_laser_nodes.append(tile_to_pixel(check_x, check_y))
				
				var laser = Line2D.new()
				laser.width = 50
				laser.default_color = Color.RED
				
				var board_node = get_parent().get_parent().get_node_or_null("Map")
				board_node.add_child(laser)
				for coord in pixel_laser_nodes:
					laser.add_point(coord)
				
				await get_tree().create_timer(2).timeout
				laser.queue_free()
				board_node.remove_child(laser)
				anim_player.play(direction + "_idle")
				
				# after firing, trigger damage card for hit player
				return
		# if not, then go to next iteration of the loop
	# if its checked everything in a row, then no robot found, so stop
	print("No target found, stand down")

func tile_to_pixel(tile_x, tile_y):
	return Game.current_board.ORIGIN + Vector2(tile_x * Game.current_board.PIXEL_X, tile_y * Game.current_board.PIXEL_Y) + Vector2(Game.current_board.PIXEL_X / 2, Game.current_board.PIXEL_Y / 2)

func _ready() -> void:
	print(Game.current_board.ORIGIN)
		
	player_decision_end.connect(Callable(self, "_on_all_decided"))
	
	#pos_x = pos_x * PIXEL_X # Pixel Pos
	#pos_y = pos_y * PIXEL_Y # Pixel Pos
	# This is why the location is the way it is, the 
	# board tiles that I used for the elements are based
	# on my tile numbering, not the one used here.
	#Dont know which one I should change.
	
	
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

func _process(delta: float) -> void:
	pass
	#if boardScript == null:
		#var board_node = get_parent().get_parent().get_node_or_null("Map")
		#print(board_node == null)
		#if board_node and board_node.get_child_count() > 0:
			## The first child under Board is the active board scene
			#boardScript = board_node.get_child(0)
			#print("Board found")




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
