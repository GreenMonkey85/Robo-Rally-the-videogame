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
	$Sprite.texture = cardData.sprite
	if $Sprite.texture != null:
		var tex_size = $Sprite.texture.get_size()
		$Sprite.scale = hand_target_size / tex_size
	else:
		$Sprite.scale = Vector2(1, 1)

# Initializes the card, getting the AnimationPlayer node
func _ready():
	anim = get_node("Anim")

# Updates the card's position while dragging
func _process(delta):
	if dragging and Game.cardSelected:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset

# Handles mouse hover entering, plays selection animation
func _on_mouse_entered() -> void:
	if anim:
		anim.play("Select")
	cardHighlighted = true

# Handles mouse hover exiting, plays deselection animation
func _on_mouse_exited() -> void:
	if anim:
		anim.play("Deselect")
	cardHighlighted = false

# Handles mouse input for dragging and placing the card
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Mouse button pressed: start dragging
		if event.pressed and cardHighlighted and !Game.cardSelected:
			Game.cardSelected = true
			dragging = true
			var mouse_pos = get_viewport().get_mouse_position()
			drag_offset = global_position - mouse_pos
			original_parent = get_parent()
			original_position = global_position
			if holder != null and holder.has_method("removePlacedCard"):
				holder.removePlacedCard()
				holder = null
			if get_child_count() > 0:
				get_child(0).show()
		# Mouse button released: stop dragging and place card
		elif !event.pressed and Game.cardSelected:
			dragging = false
			if Game.currentPlacement != null:
				Game.currentPlacement.placeCard(self)
			else:
				if original_parent != null:
					if get_parent() != original_parent:
						get_parent().remove_child(self)
						original_parent.add_child(self)
					global_position = original_position
			Game.cardSelected = false
