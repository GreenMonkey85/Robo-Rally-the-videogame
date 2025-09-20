extends Resource
class_name Deck

@export var cards: Array[Resource] = []

func shuffle():
	cards.shuffle()
