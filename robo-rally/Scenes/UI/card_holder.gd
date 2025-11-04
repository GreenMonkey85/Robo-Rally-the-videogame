extends Container

var cardHeld = ""

func setSprite(sprite):
	$cardBacks.texture = sprite

func _process(delta):
	self.global_position = get_global_mouse_position()
