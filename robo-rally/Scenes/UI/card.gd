extends Container

@onready var card = preload("res://Scenes/UI/cardHolder.tscn")
var cardHighlighted = false
var anim: AnimationPlayer
var holder = null

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
			# Check if the mouse is over a placement slot
			if Game.currentPlacement != null and !Game.currentPlacement.occupied:
				# Place card on the hovered CardPlacement
				Game.currentPlacement.placeCard()
				self.queue_free()  # remove the card from hand after placement
			else:
				# Return to hand if slot is occupied or not over a placement
				for c in holder.get_children():
					c.queue_free()
				self.get_child(0).show()

			# Clear drag card
			for c in holder.get_children():
				c.queue_free()

			Game.cardSelected = false
