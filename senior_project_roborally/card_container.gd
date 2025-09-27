extends HBoxContainer

var startPosition
var maxCardsAllowed = 9


func _ready():
	self.size.x = maxCardsAllowed*105
	self.pivot_offset.x = maxCardsAllowed*52.5
	var projectionResolution = ProjectSettings.get_setting("display/window/size/viewport_width")
	var projectionResolutionHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
	self.global_position.x = projectionResolution/4
	self.global_position.y = (projectionResolutionHeight) - 60
	startPosition = self.position

func _on_mouse_entered() -> void:
	Game.mouseOnPlacement = true


func _on_mouse_exited() -> void:
	Game.mouseOnPlacement = false
	
