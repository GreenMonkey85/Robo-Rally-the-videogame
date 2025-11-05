extends Control

var placed_card: Node = null

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true
	Game.currentPlacement = self
	
func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false
	Game.currentPlacement = null

func placeCard(card_instance: Node) -> void:
	if card_instance == null:
		Game.cardSelected = false
		return

	# If the same card is already placed here
	if placed_card == card_instance:
		Game.cardSelected = false
		return

	# Remove the current card in this slot if there is one
	if placed_card != null:
		placed_card.holder = null
		placed_card.queue_free()
		placed_card = null

	# Reparent the new card to this slot
	if card_instance.get_parent() != null:
		card_instance.get_parent().remove_child(card_instance)
	add_child(card_instance)
	card_instance.position = Vector2.ZERO

	# 🔧 FIXED SCALING: smaller and centered
	if card_instance is Control:
		card_instance.scale = Vector2(0.6, 0.6)  # Adjust 0.6 as needed
		card_instance.position = (self.size - (card_instance.size * card_instance.scale)) / 2

	card_instance.holder = self
	placed_card = card_instance
	Game.cardSelected = false

func removePlacedCard() -> void:
	if placed_card != null and is_instance_valid(placed_card):
		var card = placed_card
		card.holder = null
		placed_card = null
		get_tree().current_scene.add_child(card)
		card.global_position = global_position
