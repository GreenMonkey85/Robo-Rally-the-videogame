extends Container

@onready var card = preload("res://Scenes/UI/cardHolder.tscn")
var cardHighlighted = false
var anim: AnimationPlayer
var holder = null
var cardData: CardData = null

var dragging := false
var drag_offset := Vector2.ZERO
var original_parent = null
var original_position = Vector2.ZERO

# Desired size of the card in the hand
var hand_target_size := Vector2(100, 150)

# Sets the sprite for this card and scales it based on hand_target_size
func set_sprite():
	print(cardData)
	$Sprite.texture = cardData.sprite
	if $Sprite.texture != null:
		var tex_size = $Sprite.texture.get_size()
		$Sprite.scale = hand_target_size / tex_size
	else:
		$Sprite.scale = Vector2(1, 1)

func _ready():
	anim = get_node("Anim")

func _process(delta):
	if dragging and Game.cardSelected:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset

# Helper function: returns true if the card is in the hand container
func _is_in_hand() -> bool:
	return get_parent() != null and get_parent().name == "cardHolder"

func _on_mouse_entered() -> void:
	# Only play hover animations if card is in the hand (not in a register slot)
	if _is_in_hand() and anim:
		anim.play("Select")
	cardHighlighted = true

func _on_mouse_exited() -> void:
	if _is_in_hand() and anim:
		anim.play("Deselect")
	cardHighlighted = false

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		if event.pressed and cardHighlighted and !Game.cardSelected:
			Game.cardSelected = true
			dragging = true
			var mouse_pos = get_viewport().get_mouse_position()
			drag_offset = global_position - mouse_pos
			original_parent = get_parent()
			original_position = global_position

			# Detach from slot if it had one
			if holder != null and holder.has_method("removePlacedCard"):
				holder.removePlacedCard()
				holder = null

			if get_child_count() > 0:
				get_child(0).show()

		elif !event.pressed and Game.cardSelected:
			dragging = false

			# Place in current placement slot if hovering
			if Game.currentPlacement != null:
				Game.currentPlacement.placeCard(self)
			else:
				# Return to hand if not over a slot
				if original_parent != null:
					if get_parent() != original_parent:
						get_parent().remove_child(self)
						original_parent.add_child(self)
					global_position = original_position

			Game.cardSelected = false
