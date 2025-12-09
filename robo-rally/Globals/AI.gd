extends Node

func timer():
	await get_tree().create_timer(3.0)
	
func Beam(position, goal, cards, direction):
	print("BEAM CALLED:")
	var beam = [[[], position, direction, cards.duplicate(),
	 (abs(position.x - goal.x) + abs(position.y - goal.y))]]
	var beam_width = 9
	var max_depth = 5

	for i in range(max_depth):
		var candidates = []
		for state in beam:
			for card in state[3].duplicate():
				var new_state = simulate(state[0].duplicate(), state[1], card, state[2])
				var new_register = state[0].duplicate()
				new_register.append(card)
				var new_hand = state[3].duplicate()
				new_hand.erase(card)
				candidates.append([new_register, new_state[0], new_state[1], new_hand])
				
		for candidate in candidates:
			var pos_x = candidate[1].x
			var pos_y = candidate[1].y
			candidate.append(abs(pos_x - goal.x) + abs(pos_y - goal.y))
			
		candidates.sort_custom(func(a, b):
			return a[-1] < b[-1]
		)
		print("CANDIDATES: ", candidates)
		print("CHECKPOINT: ", goal)
		beam = candidates.slice(0, beam_width)
	return beam[0][0]


func DFS(position, goal, cards, direction):
	print("DFS CALLED:")
	var stack = [["", position, direction, cards.duplicate(), []]]
	var memory = {}
	var min_distance = abs(position.x - goal.x) + abs(position.y - goal.y)
	var best_register = []

	while len(stack) > 0:
		var state = stack.pop_front()
		var hand = state[3]
		print(state[0])
		if state[0] in memory or len(state[4]) > 5:
			continue
		memory[state[0]] = true
		var manhattan = abs(state[1].x - goal.x) + abs(state[1].y - goal.y)
		if state[4].size() > 0 and state[4][-1].action == "PowerUp":
			var damage_count = 0
			for i in cards:
				if i.type == "Damage":
					damage_count += 1
			manhattan -= damage_count
		if manhattan < min_distance:
			min_distance = min(manhattan, min_distance)
			best_register = state[4].duplicate()
		if len(state[4]) < 5:
			for i in hand:
				if i.type == "Damage":
					continue
				var new_state = simulate(state[4].duplicate(), state[1], i, state[2])
				var new_hand = hand.duplicate()
				new_hand.erase(i)
				var new_register = state[4].duplicate()
				new_register.append(i)
				stack.push_front([state[0] + i.name, new_state[0], new_state[1],
				 new_hand, new_register])
	return best_register

func simulate(register, position: Vector2, card, direction):	
	return call(card.action, register, position, direction, card)
		
func can_move(x1, y1, x2, y2):
	# check if wall is in the way
	return not Game.current_board.walls.has(Game.wall_key(Vector2(x1,y1),Vector2(x2,y2)))
 
func Move(register, position, direction, card):
	var pos_x = position.x
	var pos_y = position.y
	var new_x
	var new_y
	var mult = change_xy_dir(direction)
	for i in range(abs(card.num_action)):
		if card.num_action < 0:
			new_x = pos_x - mult.x
			new_y = pos_y - mult.y
		else:
			new_x = pos_x + mult.x
			new_y = pos_y + mult.y
			
		if can_move(pos_x, pos_y, new_x, new_y):
			pos_x = new_x
			pos_y = new_y
	return [Vector2(pos_x, pos_y), direction]

func Again(register, position, direction, card):
	if len(register) > 0:
		return call(register[-1].action, register, position, direction, card)
	else:
		return [position, direction]
		
func Spam(register, position, direction, card):
	return [position, direction]

func Rotate(register, position, direction, card):
	if card.num_action == 0:
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
		for i in range(abs(card.num_action)):
			# Rotate Right
			if card.num_action > 0:
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
			elif card.num_action < 0:
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
	return [position, direction]

func PowerUp(register, position, direction, card):
	return [position, direction]

func change_xy_dir(direction):
	var x_dir_mult
	var y_dir_mult
	
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

	return Vector2(x_dir_mult,y_dir_mult)
