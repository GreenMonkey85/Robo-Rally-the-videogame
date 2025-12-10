extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var preview_slot: Control = $CanvasLayer/CardPreview

func _ready() -> void:
	if not Game.is_connected("card_display", Callable(self, "card_display")):
		Game.connect("card_display", Callable(self, "card_display"))

func card_display(card):
	print("the card is: " + str(card))

	for child in preview_slot.get_children():
		child.queue_free()

	if card == null or card is String:
		return

	var preview_card: Card = CARD_SCENE.instantiate()
	preview_card.cardData = card
	preview_slot.add_child(preview_card)
	preview_card.set_sprite()

	call_deferred("_scale_preview_card", preview_card)

func _scale_preview_card(preview_card):
	if not is_instance_valid(preview_card):
		return
	if not is_instance_valid(preview_slot):
		return

	var slot_size = preview_slot.size
	var card_size = preview_card.size

	if card_size.x != 0 and card_size.y != 0:
		var scale_x = slot_size.x / card_size.x
		var scale_y = slot_size.y / card_size.y
		preview_card.scale = Vector2(scale_x, scale_y)
		preview_card.position = Vector2.ZERO
