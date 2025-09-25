extends Container

@onready var card = preload("res://cardHolder.tscn")
var startPosition
var cardHighlighted = false

func _on_mouse_entered() -> void:
	$Anim.play("Select")
	cardHighlighted = true

func _on_mouse_exited() -> void:
	$Anim.play("Deselect")
	cardHighlighted = false

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Mouse down
		if event.pressed and cardHighlighted and !Game.cardSelected:
			var holder = get_tree().get_root().get_node("Board/CardHolder")

			# Make sure holder is empty
			for c in holder.get_children():
				c.queue_free()

			# Spawn one drag card
			var dragCard = card.instantiate()
			holder.add_child(dragCard)

			Game.cardSelected = true
			self.get_child(0).hide()  # hide card in hand

		# Mouse up
		elif !event.pressed and Game.cardSelected:
			var holder = get_tree().get_root().get_node("Board/CardHolder")

			if !Game.mouseOnPlacement:
				# Not placed on board
				for c in holder.get_children():
					c.queue_free()
				self.get_child(0).show()
			else:
				#place on board
				self.queue_free()
				get_node("../../CardPlacement").placeCard()
				for i in get_tree().get_root().get_node("Board/CardHolder").get_child_count():
					#does not work if cards are different
					get_tree().get_root().get_node("Board/CardHolder").get_child(i).queue_free()
					

			Game.cardSelected = false
