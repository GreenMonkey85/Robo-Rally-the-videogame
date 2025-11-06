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

	# Prevent re-placing the same card
	if placed_card == card_instance:
		Game.cardSelected = false
		return

	# Remove previous card in this slot
	if placed_card != null:
		placed_card.holder = null
		placed_card.queue_free()
		placed_card = null

	# Reparent new card to this slot
	if card_instance.get_parent() != null:
		card_instance.get_parent().remove_child(card_instance)
	add_child(card_instance)

	# Scale the card to exactly fill the CardPlacement slot
	if card_instance is Control or card_instance is Container:
		var slot_size = self.size
		var card_size = card_instance.size
		if card_size.x != 0 and card_size.y != 0:
			var scale_x = slot_size.x / card_size.x
			var scale_y = slot_size.y / card_size.y
			card_instance.scale = Vector2(scale_x, scale_y)  # fill both width and height
			card_instance.position = Vector2.ZERO  # top-left corner of slot

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
