extends Container

@onready var card = preload("res://Scenes/UI/cardHolder.tscn")
var startPosition
var cardHighlighted = false
var anim: AnimationPlayer  # Add this variable to hold your AnimationPlayer

func _ready():
	anim = get_node("Anim")  # Cache the AnimationPlayer

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
				# Place on board
				self.queue_free()
				get_node("../../CardPlacement").placeCard()
				for i in range(holder.get_child_count()):
					holder.get_child(i).queue_free()

			Game.cardSelected = false
