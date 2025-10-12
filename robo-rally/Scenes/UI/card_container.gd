extends HBoxContainer

var startPosition
var maxCardsAllowed = 9


func _ready():
	self.size.x = maxCardsAllowed*105
	self.pivot_offset.x = maxCardsAllowed*52.5
	var projectionResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectionResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	self.global_position.x = projectionResolution/8
	self.global_position.y = (projectionResolutionHeight) - 60
	startPosition = self.position

func _on_mouse_entered() -> void:
	var target_poition = startPosition + Vector2(0, -100)
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "position", target_poition, 0.2)
	tween2.tween_property(self, "scale", Vector2(1.3,1.3), 0.2)


func _on_mouse_exited() -> void:
	if !Game.cardSelected:
		var target_poition = startPosition + Vector2(0, -100)
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "position", startPosition, 0.2)
	tween2.tween_property(self, "scale", Vector2(1,1), 0.2)
	
