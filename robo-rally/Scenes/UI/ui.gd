extends Control

const CARD_SCENE: PackedScene = preload("res://Scenes/UI/Card.tscn")

@onready var draw_button: Button = $UI/DrawPile
@onready var confirm_button: Button = $CanvasLayer/Confirm
@onready var clear_button: Button = $UI/Clear
@onready var card_container: HBoxContainer = $CanvasLayer/cardHolder
@onready var register: Control = $CanvasLayer/Register
@onready var preview_slot: Control = $UI/CardPreview  # CardPreview container
#@onready var draw_button: Button = $UI/DrawPile


var max_cards_allowed: int = 9
var start_position: Vector2

var _confirming = false

func _ready() -> void:
	$CanvasLayer.visible = false
	
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

	#print(card.sprite)
	

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
	var register_list = register.get_children()
	register_list.pop_front()
	var final_register = []
	for i in register_list:

	
		#print("card container: " + str(i.placed_card))
		#if i.placed_card == null:
			#final_register.append(i.placed_card)
		#else:
			#final_register.append(i.placed_card.cardData)
			#print("card data: " + str(i.placed_card.cardData))
	#
	#for each in register_list:
		#each.clear_register()

		
		if i.placed_card != null:
			print("CONFIRM CARD ", i.placed_card.cardData, " ", i, " ")
			final_register.append(i.placed_card.cardData)
		else:
			final_register.append(null)
		print("BEFORE ", i)
		i.clear_register()
		print("AFTER ", i)
	get_parent().decision_end(final_register)

# Clear button
func _on_clear_pressed() -> void:
	for slot in register.get_children():
		print("SLOT", slot)
		if slot.get_child_count() > 0:
			var card = slot.get_child(0)
			print("CLEAR CARD", card)
			if card.has_method("return_to_hand"):
				card.return_to_hand()

func show_card_preview(card_data: CardData): # CardData only when AI player
	if preview_slot == null: 
		push_warning("CardPreview node not found!")
		return

func _on_shut_down_pressed() -> void:
	for slot in register.get_children():
		if slot.get_child_count() > 0:
			var card = slot.get_child(0)
			if card != null and card.has_method("return_to_hand"):
				card.return_to_hand()
			elif card != null:
				card.queue_free()
				
	var register_list = register.get_children()
	register_list.pop_front()

	var final_register = []
	for slot in register_list:
		final_register.append(null)
	get_parent().decision_end(final_register)
