extends Control

@onready var card_scene: PackedScene = preload("res://Scenes/UI/cardOnBoard.tscn")
var occupied := false

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true
	Game.currentPlacement = self

func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false
	Game.currentPlacement = null

func placeCard():
	if occupied:
		Game.cardSelected = false
		return

	var card_instance = card_scene.instantiate()
	add_child(card_instance)
	card_instance.global_position = self.global_position

	if card_instance is Control:
		var placement_size = self.size
		var card_size = card_instance.size
		if card_size.x != 0 and card_size.y != 0:
			card_instance.scale = placement_size / card_size

	occupied = true

func resetSlot():
	occupied = false
	for c in get_children():
		c.queue_free()
