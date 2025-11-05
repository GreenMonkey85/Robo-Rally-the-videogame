extends HBoxContainer

var startPosition := Vector2.ZERO
var card_width := 100
var hand_target_spacing := 10  # spacing between cards

func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	refresh_hand()

func _recenter_hand():
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var total_cards = get_child_count()
	if total_cards == 0:
		return

	var total_width = total_cards * card_width + (total_cards - 1) * hand_target_spacing
	if total_width > screen_width:
		hand_target_spacing = (screen_width - total_cards * card_width) / max(total_cards - 1, 1)
		if hand_target_spacing < 0:
			hand_target_spacing = 0

	for i in range(total_cards):
		var card = get_child(i)
		card.position.x = i * (card_width + hand_target_spacing)
		card.position.y = 0

	self.position.x = (screen_width - total_width) / 2
	startPosition = self.position

func _on_mouse_entered() -> void:
	for card in get_children():
		if not card.dragging:
			var tween = get_tree().create_tween()
			tween.tween_property(card, "position", card.position + Vector2(0, -100), 0.2)
			tween.tween_property(card, "scale", Vector2(1.1, 1.1), 0.2)

func _on_mouse_exited() -> void:
	for card in get_children():
		if not card.dragging:
			var tween = get_tree().create_tween()
			tween.tween_property(card, "position", card.position, 0.2)
			tween.tween_property(card, "scale", Vector2(1, 1), 0.2)

func refresh_hand():
	_recenter_hand()
