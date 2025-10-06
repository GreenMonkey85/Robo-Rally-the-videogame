extends Node

# Path to your Card.tscn (update if needed)
const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var draw_button: Button = $UI/CardPlacement/DrawPile
@onready var card_container: HBoxContainer = $UI/cardHolder

var max_cards_allowed: int = 9
var start_position: Vector2

func _ready() -> void:
	if draw_button:
		draw_button.pressed.connect(_on_draw_button_pressed)

	if not card_container:
		push_warning("Card container not found at $UI/cardHolder")
		return

	var vw: float = ProjectSettings.get_setting("display/window/size/viewport_width")
	var vh: float = ProjectSettings.get_setting("display/window/size/viewport_height")

	card_container.size.x = max_cards_allowed * 105
	card_container.pivot_offset.x = max_cards_allowed * 52.5
	card_container.global_position = Vector2(vw / 4.0, vh - 60.0)
	start_position = card_container.position

	card_container.mouse_filter = Control.MOUSE_FILTER_STOP
	card_container.mouse_entered.connect(_on_mouse_entered)
	card_container.mouse_exited.connect(_on_mouse_exited)

func _on_draw_button_pressed() -> void:
	if not CARD_SCENE or not card_container:
		return

	# Clear old cards
	for c in card_container.get_children():
		c.queue_free()

	# Add new cards to container
	for i in range(max_cards_allowed):
		var new_card = CARD_SCENE.instantiate()
		card_container.add_child(new_card)

func _on_mouse_entered() -> void:
	var target = start_position + Vector2(0, -100)
	var tween = get_tree().create_tween()
	tween.tween_property(card_container, "position", target, 0.2)
	tween.tween_property(card_container, "scale", Vector2(1.3, 1.3), 0.2)

func _on_mouse_exited() -> void:
	if not (Engine.has_singleton("Game") and Game.cardSelected):
		var tween = get_tree().create_tween()
		tween.tween_property(card_container, "position", start_position, 0.2)
		tween.tween_property(card_container, "scale", Vector2(1, 1), 0.2)
