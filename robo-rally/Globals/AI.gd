extends Node

func Optimal(position, goal, cards, direction):
	var stack = [["", position, direction, cards.duplicate(), []]]
	var memory = {}
	var min_distance = abs(position.x - goal.x) + abs(position.y - goal.y)
	var best_register = []

	while len(stack) > 0:
		var state = stack.pop_front()
		var hand = state[3]
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
				var new_state = simulate(state[4], state[1].clone(), i, state[2])
				var new_hand = hand.duplicate()
				new_hand.erase(i)
				stack.push_front([state[0] + i.name, new_state[0], new_state[1],
				 new_hand, state[4].duplicate().append(i)])
	return best_register

func simulate(register, position: Vector2, card, direction):
	return call(card.action, register, position, direction, card)
		
func can_move(x1, y1, x2, y2):
	# check if wall is in the way
	return Game.current_board.walls.has(Game.wall_key(Vector2(x1,y1),Vector2(x2,y2)))
 
func Move(register, position, direction, card):
	var new_x = position.x
	var new_y = position.y
	var mult = change_xy_dir(direction)
	for i in range(abs(card.num_action)):
		if card.num_action < 0:
			new_x = position.x - mult.x
			new_y = position.y - mult.y
		else:
			new_x = position.x + mult.x
			new_y = position.y + mult.y
			
		if can_move(position.x, position.y, new_x, new_y):
			position.x = new_x
			position.y = new_y
	return [position, direction]

func Again(register, position, direction, card):
	if len(register) > 0:
		return call(register[-1].action, register, position, direction, card)
	else:
		return [position, direction]

func Rotate(register, position, direction, num_actions):
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
