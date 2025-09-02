@tool
extends Node2D
class_name CarouselContainer

@export var spacing: float = 20.0
@export var opacity_strength: float = 0.35
@export var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1
@export var smoothing_speed: float = 6.5
@export var selected_index: int = 0
@export var position_offset_node: Control = null

func _get_node_size(node: Control) -> Vector2:
	return node.get_size()

func _ready() -> void:
	if not position_offset_node:
		push_error("CarouselContainer: position_offset_node not assigned")
		return
	print("Carousel ready with children:", position_offset_node.get_child_count())

func _process(delta: float) -> void:
	if not position_offset_node:
		return
	var child_count = position_offset_node.get_child_count()
	if child_count == 0:
		return
	selected_index = clamp(selected_index, 0, child_count - 1)

	for i in position_offset_node.get_children():
		var node_size = _get_node_size(i)
		var pos_x = 0.0
		if i.get_index() > 0:
			var prev = position_offset_node.get_child(i.get_index() - 1)
			pos_x = prev.position.x + _get_node_size(prev).x + spacing
		i.position = Vector2(pos_x, 0)

		i.pivot_offset = node_size / 2
		var target_scale = 1.0 - scale_strength * abs(i.get_index() - selected_index)
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed * delta)

		var target_opacity = 1.0 - opacity_strength * abs(i.get_index() - selected_index)
		target_opacity = clamp(target_opacity, 0.0, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)

		if i.get_index() == selected_index:
			i.z_index = 1
		else:
			i.z_index = -abs(i.get_index() - selected_index)

func _left():
	print("Left pressed")

func _right():
	print("Right pressed")
