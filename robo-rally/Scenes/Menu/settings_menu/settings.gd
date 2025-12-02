extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inst = Game.TITLE_MENU.instantiate()
	print("Instance =", inst)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	#print("TITLE_MENU =", Game.TITLE_MENU)
	#print("Type =", typeof(Game.TITLE_MENU))
#
	#if Game.TITLE_MENU is PackedScene:
		#print("TITLE_MENU is a Packed Scene!")
	#
	#print("Tree paused?: ", get_tree().paused)
	#
	#print("Current scene:", get_tree().current_scene)
	#print("Current scene name:", get_tree().current_scene.name)
	#
	#print("Is current scene the root?", get_tree().root == get_tree().current_scene.get_parent())
	#
	#print_tree_pretty()
	#
	#print("Root name:", get_tree().root.name)
	#print("Current scene name:", get_tree().current_scene.name)
	#print("Are they the same object?:", get_tree().root == get_tree().current_scene)
	
	#var err = get_tree().change_scene_to_packed(Game.TITLE_MENU)
	#print("change_scene_to_packed returned:", err)
	#
	#var err2 = get_tree().change_scene_to_file("res://Scenes/Menu/title_menu/main_menu.tscn")
	#print("change_scene_to_file returned:", err)
	#
	#print("SELF IN TREE?: ", is_inside_tree())
	#print("TREE EXISTS?: ", get_tree() != null)
	
	#get_tree().root.call_deferred("change_scene_to_packed", Game.TITLE_MENU)
	#
	get_tree().change_scene_to_packed(Game.TITLE_MENU)
	#await get_tree().process_frame
	#print("current after frame:", get_tree().current_scene)
