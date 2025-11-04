extends Container

@onready var card = preload("res://Scenes/UI/cardHolder.tscn")
var cardHighlighted = false
var anim: AnimationPlayer
var holder = null
var cardData: CardData = null

func set_sprite():
	$Sprite.texture = cardData.sprite
var dragging := false
var drag_offset := Vector2.ZERO  # Mouse-to-card offset

func _ready():
	anim = get_node("Anim")

func _process(delta):
	if dragging and Game.cardSelected:
		var mouse_pos = get_viewport().get_mouse_position()
		global_position = mouse_pos + drag_offset

func _on_mouse_entered() -> void:
	if anim:
		anim.play("Select")
	cardHighlighted = true

func _on_mouse_exited() -> void:
	if anim:
		anim.play("Deselect")
	cardHighlighted = false

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:

		# Mouse down
		if event.pressed and cardHighlighted and !Game.cardSelected:
			Game.cardSelected = true
			dragging = true
			var mouse_pos = get_viewport().get_mouse_position()
			drag_offset = global_position - mouse_pos  # Center drag

			# Release this card from its current slot
			if holder != null and holder.has_method("removePlacedCard"):
				holder.removePlacedCard()
				holder = null  # Clear holder so it can go back to same slot

			if get_child_count() > 0:
				get_child(0).show()

		# Mouse up
		elif !event.pressed and Game.cardSelected:
			dragging = false

			# Place in current placement slot if hovering
			if Game.currentPlacement != null:
				Game.currentPlacement.placeCard(self)
			else:
				# Return to hand if not over a slot
				if holder != null:
					global_position = holder.global_position

			Game.cardSelected = false
