extends Control

var placed_card: Node = null  # The card currently in this slot

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true
	Game.currentPlacement = self

func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false
	if not Game.cardSelected:
		Game.currentPlacement = null

func placeCard(card_instance: Node) -> void:
	if card_instance == null:
		Game.cardSelected = false
		return

	# Step 1: If this slot already has a card, send it back to hand
	if placed_card != null and is_instance_valid(placed_card):
		placed_card.return_to_hand()
		placed_card = null

	# Step 2: If the card was in another slot, tell that slot to clear itself
	if card_instance.holder != null and card_instance.holder != self and card_instance.holder.has_method("removePlacedCard"):
		card_instance.holder.removePlacedCard()

	# Step 3: Reparent the card to this slot
	if card_instance.get_parent() != null:
		card_instance.get_parent().remove_child(card_instance)
	add_child(card_instance)

	# Step 4: Scale and position the card to fill the slot
	if card_instance is Control or card_instance is Container:
		var slot_size = self.size
		var card_size = card_instance.size
		if card_size.x != 0 and card_size.y != 0:
			var scale_x = slot_size.x / card_size.x
			var scale_y = slot_size.y / card_size.y
			card_instance.scale = Vector2(scale_x, scale_y)
			card_instance.position = Vector2.ZERO

	# Step 5: Update slot reference and card holder
	card_instance.holder = self
	placed_card = card_instance
	Game.cardSelected = false

func removePlacedCard() -> void:
	if placed_card != null and is_instance_valid(placed_card):
		placed_card.holder = null
		placed_card = null
