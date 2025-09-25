extends HBoxContainer

@onready var card = preload("res://cardOnBoard.tscn")

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true


func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false
	

func placeCard():
	var cardTemp = card.card_instantiate()
	var projectionResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	cardTemp.global_position = Vector2(projectionResolution/2, projectResolutionHeight/2) - self.position
	add_child(cardTemp)
