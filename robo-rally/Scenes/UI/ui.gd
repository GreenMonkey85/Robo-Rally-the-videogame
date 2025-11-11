extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

#@onready var draw_button: Button = $UI/DrawPile
@onready var confirm_button: Button = $CanvasLayer/Confirm
@onready var card_container: HBoxContainer = $CanvasLayer/cardHolder

var max_cards_allowed: int = 9
var start_position: Vector2

var _confirming = false

func _ready() -> void:
	$CanvasLayer.visible = false
	
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

func draw_animation(card: CardData):
	var new_card = CARD_SCENE.instantiate()
	new_card.holder = $CanvasLayer/CardHolder
	new_card.cardData = card
	new_card.set_sprite()
	card_container.add_child(new_card)
	#print(card.sprite)
	

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card_container, "position", start_position + Vector2(0, -100), 0.2)
	tween.tween_property(card_container, "scale", Vector2(1.1, 1.1), 0.2)

func _on_mouse_exited() -> void:
	if not (Engine.has_singleton("Game") and Game.cardSelected):
		var tween = get_tree().create_tween()
		tween.tween_property(card_container, "position", start_position, 0.2)
		tween.tween_property(card_container, "scale", Vector2(1, 1), 0.2)

func _on_confirm_pressed() -> void:
	if _confirming:
		return
	_confirming = true
		
	if not card_container:
		return
	for card in card_container.get_children():
		card.queue_free()
	await get_parent().decision_end()
