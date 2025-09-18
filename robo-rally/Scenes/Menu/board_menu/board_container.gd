extends Node2D
class_name CarouselContainer

@export var panel_width: float = 500.0
@export var spacing_between: float = 100.0
@export var transition_speed: float = 8.0

var current_index: int = 0
var panels: Array[Control] = []
var target_offset: float = 0.0
var current_offset: float = 0.0

var carousel: Node2D
var control: Control
var left_button: Button
var right_button: Button
var select_button: Button

func _ready() -> void:
	carousel = get_node_or_null("CarouselConatianer")
	if not carousel:
		push_error("CarouselConatianer node not found under root")
		return

	for child in carousel.get_children():
		if child is Control:
			control = child
			break

	left_button = get_node_or_null("left")
	right_button = get_node_or_null("right")
	select_button = get_node_or_null("select")  # Make sure this is the correct path

	if not control:
		push_error("No Control node found inside CarouselConatianer")
		return

	for child in control.get_children():
		if child is Panel:
			panels.append(child)

	var spacing = panel_width + spacing_between
	for i in range(panels.size()):
		panels[i].position.x = i * spacing

	if left_button:
		left_button.pressed.connect(_on_left_pressed)
	if right_button:
		right_button.pressed.connect(_on_right_pressed)
	if select_button:
		select_button.pressed.connect(_on_select_pressed)
	else:
		push_warning("Select button not found! Make sure the node path is correct.")

	_update_target()

func _process(delta: float) -> void:
	if control:
		current_offset = lerp(current_offset, target_offset, delta * transition_speed)
		control.position = Vector2(-current_offset, 0)

func _on_left_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		_update_target()

func _on_right_pressed() -> void:
	if current_index < panels.size() - 1:
		current_index += 1
		_update_target()

func _update_target() -> void:
	target_offset = float(current_index * (panel_width + spacing_between))

func _on_select_pressed() -> void:
	if panels.size() > 0:
		print("Selected panel:", current_index, "->", panels[current_index].name)
	else:
		print("No panels found!")
	
