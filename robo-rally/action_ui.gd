extends CanvasLayer

#handle card_display signal
func card_display(card):
	print("the card is: " + card)
	
func _ready():
	print("ready function ActionUI")
