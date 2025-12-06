extends Control

@onready var card_preview = $CanvasLayer/CardPreview

func _process(_delta):
	if visible:
		if Game.current_action_card != null:
			card_preview.show_card(Game.current_action_card)
	else:
		card_preview.hide_card()
