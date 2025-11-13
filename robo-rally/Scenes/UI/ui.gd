extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var draw_button: Button = $UI/DrawPile
@onready var confirm_button: Button = $UI/Confirm
@onready var clear_button: Button = $UI/Clear
@onready var card_container: HBoxContainer = $UI/cardHolder
@onready var register: Control = $UI/Register
@onready var preview_slot: Control = $UI/CardPreview  # CardPreview container

var max_cards_allowed: int = 9
var start_position: Vector2

func _ready() -> void:
	if confirm_button:
		confirm_button.pressed.connect(_on_confirm_pressed)

	if clear_button:
		clear_button.pressed.connect(_on_clear_pressed)

	if not card_container:
		push_warning("Card container not found at $UI/cardHolder")
		return

	var vw: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var vh: float = ProjectSettings.get_setting("display/window/size/viewport_height")

	var hand_width: float = max_cards_allowed * 105.0
	card_container.size.x = hand_width
	card_container.pivot_offset.x = hand_width / 2.0
	card_container.global_position = Vector2((vw - hand_width) / 2.0, vh - 60.0)
	start_position = card_container.position

	card_container.mouse_filter = Control.MOUSE_FILTER_STOP
	card_container.mouse_entered.connect(_on_mouse_entered)
	card_container.mouse_exited.connect(_on_mouse_exited)

# Draw a card animation in hand
func draw_animation(card: CardData):
	var new_card = CARD_SCENE.instantiate()
	new_card.holder = card_container
	new_card.cardData = card
	new_card.set_sprite()
	card_container.add_child(new_card)

# Hover animation for hand
func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card_container, "position", start_position + Vector2(0, -100), 0.2)
	tween.tween_property(card_container, "scale", Vector2(1.1, 1.1), 0.2)

func _on_mouse_exited() -> void:
	if not (Engine.has_singleton("Game") and Game.cardSelected):
		var tween = get_tree().create_tween()
		tween.tween_property(card_container, "position", start_position, 0.2)
		tween.tween_property(card_container, "scale", Vector2(1, 1), 0.2)

# Confirm button
func _on_confirm_pressed() -> void:
	for card in card_container.get_children():
		card.queue_free()
	register.visible = false
	get_parent().decision_end()

# Clear button
func _on_clear_pressed() -> void:
	for slot in register.get_children():
		if slot.get_child_count() > 0:
			var card = slot.get_child(0)
			if card.has_method("return_to_hand"):
				card.return_to_hand()

func show_card_preview(card_data: CardData):
	if preview_slot == null:
		push_warning("CardPreview node not found!")
		return

	# Reuse existing preview card if it exists
	var preview_card: Node
	if preview_slot.get_child_count() > 0:
		preview_card = preview_slot.get_child(0)
	else:
		preview_card = CARD_SCENE.instantiate()
		preview_slot.add_child(preview_card)
		preview_card.dragging = false  # disable drag
		preview_card.holder = null
		preview_card.position = Vector2.ZERO

	# Set card data and sprite
	preview_card.cardData = card_data
	preview_card.set_sprite()

	# Scale to fill the preview slot
	if preview_card is Control or preview_card is Container:
		var slot_size = preview_slot.size
		var card_size = preview_card.size
		if card_size.x != 0 and card_size.y != 0:
			var scale_x = slot_size.x / card_size.x
			var scale_y = slot_size.y / card_size.y
			preview_card.scale = Vector2(scale_x, scale_y)
			preview_card.position = Vector2.ZERO
