extends Node2D

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

var num_players
var num_AI
var num_humans

var names_not_selected = []
@onready var error = $Panel/Error

#@onready var settingsMessage = $Panel/SettingsMessage

func _ready() -> void:
	num_players = Game.num_players
	num_AI = Game.num_AI
	num_humans = num_players - num_AI
	
	#settingsMessage.text = "
		#Can change the player count in Setting & Game Info
		#Total players: " + str(num_players) + "
		#Human: " + str(num_humans) + "
		#AI: " + str(num_AI) + "
	#"
	
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
	select_button = get_node_or_null("select")

	for child in control.get_children():
		if child is Panel:
			panels.append(child)

	var spacing = panel_width + spacing_between
	var left = -135
	for i in range(panels.size()):
		panels[i].position.x = i * spacing + left
	
	for i in panels:
		names_not_selected.append(i.name)

	if left_button:
		left_button.pressed.connect(_on_left_pressed)
	if right_button:
		right_button.pressed.connect(_on_right_pressed)
	if select_button:
		select_button.pressed.connect(_on_select_pressed)

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
	#if panels.size() > 0:
		#print("Selected panel:", current_index, "->", panels[current_index].name)
	var characters = panels.duplicate()
	
	print(names_not_selected)
	print(panels[current_index])
	print(panels[current_index].name)
	print(panels[0].name == names_not_selected[0])
	
	if panels[current_index].name in names_not_selected:
		names_not_selected.erase(panels[current_index].name)
		
		var robot = preload("res://Scenes/Characters/robot.tscn").instantiate()
		# robot.set_character(panels.pop_at(current_index).name)
		robot.set_character(panels[current_index].name)
		Game.player_order.append(robot)
		
		num_humans -= 1
		if num_humans == 0:
			for i in range(num_AI):
				robot = preload("res://Scenes/Characters/robot.tscn").instantiate()
				# robot.set_character(panels[0].name)
				robot.set_character(names_not_selected[0])
				names_not_selected.remove_at(0)
				robot.player = "Beam"
				Game.player_order.append(robot)
		
		#for i in range(3):
			#robot = preload("res://Scenes/Characters/robot.tscn").instantiate()
			#robot.set_character(panels[0].name)
			#Game.player_order.append(robot)
			get_tree().change_scene_to_packed(Game.BOARD_MENU)
	else:
		error.visible = true


func _on_quit_pressed() -> void:
	print("quit to title")
	Game.reset_request = true
	get_tree().change_scene_to_file("res://Scenes/Menu/title_menu/main_menu.tscn")
