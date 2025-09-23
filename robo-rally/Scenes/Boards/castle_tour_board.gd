extends Node2D


#@onready var hammer : CharacterBody2D = $HammerBot
#@onready var p1cam : Camera2D = $HammerBot/P1Camera

#startinglocation_x = (grid_x - grid_y) * (tile_width / 2)
#startinglocation_y = (grid_x + grid_y) * (tile_height / 2)
# number 1 on castle tour is (-3, -1) according to bottom left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var tween = create_tween()
	#tween.tween_property(hammer, "position", Vector2(-852, -1704), 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
