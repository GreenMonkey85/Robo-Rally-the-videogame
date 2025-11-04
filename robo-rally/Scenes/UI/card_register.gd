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

	# If the card is already here, keep it (allows re-placement)
	if placed_card == card_instance:
		Game.cardSelected = false
		return

	# Remove any other card in this slot
	if placed_card != null:
		placed_card.holder = null
		placed_card.queue_free()
		placed_card = null

	# Reparent card to this slot
	if card_instance.get_parent() != null:
		card_instance.get_parent().remove_child(card_instance)
	add_child(card_instance)
	card_instance.position = Vector2.ZERO

	# Scale to fit
	if card_instance is Control:
		var placement_size = self.size
		var card_size = card_instance.size
		if card_size.x != 0 and card_size.y != 0:
			card_instance.scale = placement_size / card_size

	# Update holder reference
	card_instance.holder = self
	placed_card = card_instance
	Game.cardSelected = false

func removePlacedCard() -> void:
	# Detach card for dragging
	if placed_card != null and is_instance_valid(placed_card):
		var card = placed_card
		card.holder = null
		placed_card = null
		get_tree().current_scene.add_child(card)
		card.global_position = global_position
