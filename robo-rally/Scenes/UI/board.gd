extends Node

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var draw_button: Button = $UI/DrawPile
@onready var confirm_button: Button = $UI/ConfirmButton
@onready var card_container: HBoxContainer = $UI/cardHolder

var max_cards_allowed: int = 9
var start_position: Vector2
var register_slots = []

func _ready() -> void:
	if draw_button:
		draw_button.pressed.connect(_on_draw_button_pressed)
	if confirm_button:
		confirm_button.pressed.connect(_on_confirm_pressed)

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

	# Cache register slots
	register_slots = [
		$UI/CardPlacement,
		$UI/CardPlacement2,
		$UI/CardPlacement3,
		$UI/CardPlacement4,
		$UI/CardPlacement5
	]

func _on_draw_button_pressed() -> void:
	if not CARD_SCENE or not card_container:
		return

	# Clear existing hand
	for c in card_container.get_children():
		c.queue_free()

	# Draw new cards
	for i in range(max_cards_allowed):
		var new_card = CARD_SCENE.instantiate()
		new_card.holder = card_container
		card_container.add_child(new_card)

func _on_confirm_pressed() -> void:
	if not card_container:
		return
	for card in card_container.get_children():
		card.queue_free()

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card_container, "position", start_position + Vector2(0, -100), 0.2)
	tween.tween_property(card_container, "scale", Vector2(1.1, 1.1), 0.2)

func _on_mouse_exited() -> void:
	if not (Engine.has_singleton("Game") and Game.cardSelected):
		var tween = get_tree().create_tween()
		tween.tween_property(card_container, "position", start_position, 0.2)
		tween.tween_property(card_container, "scale", Vector2(1, 1), 0.2)
