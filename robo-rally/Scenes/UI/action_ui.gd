extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var checkpoints: Label = $CanvasLayer/CheckpointsContainer/Checkpoints
@onready var preview_slot: Control = $CanvasLayer/CardPreview

func card_display(card):
	print("the card is: " + str(card))

	# Clear preview
	for child in preview_slot.get_children():
		child.queue_free()

	# Load empty preview card (spam) or actual card
	var preview_card: Card = CARD_SCENE.instantiate()

	if card == null:
		var spam := preload("res://Resources/Cards/Damage_Cards/spam.tres")
		preview_card.cardData = spam
	else:
		preview_card.cardData = card

	preview_slot.add_child(preview_card)
	preview_card.set_sprite()

	call_deferred("_scale_preview_card", preview_card)


func _scale_preview_card(preview_card):
	if not is_instance_valid(preview_card) or not is_instance_valid(preview_slot):
		return

	var slot_size = preview_slot.size
	var card_size = preview_card.size

	if card_size.x != 0 and card_size.y != 0:
		var scale_x = slot_size.x / card_size.x
		var scale_y = slot_size.y / card_size.y
		preview_card.scale = Vector2(scale_x, scale_y)
		preview_card.position = Vector2.ZERO


func _on_checkpoints_reached(numCheckpoints):
	print("Checkpoints reached: " + str(numCheckpoints))

	checkpoints.text = "Last Checkpoint Reached: " + str(numCheckpoints)
	checkpoints.modulate = Color8(248, 141, 0)

	call_deferred("_scale_checkpoints_label")


func _scale_checkpoints_label():
	if not is_instance_valid(checkpoints):
		return

	var parent := checkpoints.get_parent()

	if not parent is Control:
		push_warning("Checkpoints parent must be a Control node!")
		return

	var parent_size = parent.size
	var label_size = checkpoints.size

	if label_size.x != 0 and label_size.y != 0:
		var scale_x = parent_size.x / label_size.x
		var scale_y = parent_size.y / label_size.y
		checkpoints.scale = Vector2(scale_x, scale_y)
		checkpoints.position = Vector2.ZERO
