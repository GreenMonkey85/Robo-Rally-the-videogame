extends Container

@onready var anim: AnimationPlayer = $Anim
var cardHighlighted = false
var holder = null  # Current register slot (CardPlacement) this card is in
var cardData: CardData = null

var dragging := false
var drag_offset := Vector2.ZERO
var original_parent = null
var original_position = Vector2.ZERO

# Desired size of the card in the hand
var hand_target_size := Vector2(100, 150)

func _ready():
	pass  # anim is already assigned via @onready

func set_sprite():
	print(cardData)
	$Sprite.texture = cardData.sprite
	if $Sprite.texture != null:
		var tex_size = $Sprite.texture.get_size()
		$Sprite.scale = hand_target_size / tex_size
	else:
		$Sprite.scale = Vector2(1, 1)

func _process(delta):
	if dragging and Game.cardSelected:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset

# Only cards in the hand are draggable and have hover animation
func _is_in_hand() -> bool:
	return get_parent() != null and get_parent().name == "cardHolder"

func _on_mouse_entered() -> void:
	if _is_in_hand() and anim:
		anim.play("Select")
	cardHighlighted = true

func _on_mouse_exited() -> void:
	if _is_in_hand() and anim:
		anim.play("Deselect")
	cardHighlighted = false

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		# Start dragging only if in hand
		if event.pressed and cardHighlighted and not Game.cardSelected and _is_in_hand():
			Game.cardSelected = true
			dragging = true
			var mouse_pos = get_viewport().get_mouse_position()
			drag_offset = global_position - mouse_pos

			# Save original parent and position for returning
			original_parent = get_parent()
			original_position = global_position

			# Detach from current slot if any
			if holder != null and holder.has_method("removePlacedCard"):
				holder.removePlacedCard()
				holder = null

		elif not event.pressed and Game.cardSelected:
			dragging = false

			# If hovering over a register slot, place the card
			if Game.currentPlacement != null:
				Game.currentPlacement.placeCard(self)
			else:
				# Return to hand only if originally in hand
				if _is_in_hand() and original_parent != null:
					return_to_hand()

			Game.cardSelected = false

func return_to_hand():
	if original_parent != null:
		if get_parent() != original_parent:
			get_parent().remove_child(self)
			original_parent.add_child(self)
		global_position = original_position
		holder = null  # No longer in a slot
