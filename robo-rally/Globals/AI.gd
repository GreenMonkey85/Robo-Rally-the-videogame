extends Node

func Optimal(position, goal, cards, direction):
	var path = []
	var stack = [[Vector2(position.x, position.y), path.duplicate()]]
	var memory = {}
	
	while len(stack) > 0:
		var card = stack.pop_front()
		if card in memory:
			continue
		memory[card] = true
		for i in cards:
			stack.push_front(path)
