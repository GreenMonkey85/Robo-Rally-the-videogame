extends Node2D

#@onready var robot : CharacterBody2D = $Robot
#@onready var p1cam : Camera2D = $Robot/P1Camera

#startinglocation_x = (grid_x - grid_y) * (tile_width / 2)
#startinglocation_y = (grid_x + grid_y) * (tile_height / 2)

#@onready var hammer_x = 0
#@onready var hammer_y = 0
#@onready var hammer_direction = "bl"
#@onready var hammer_shutdown = false
#
#@onready var hammer_animationPlayer : AnimationPlayer = $Robot/Sprite2D/AnimationPlayer

@onready var walls = { # start space is (0,0). up is x-1,y-1. down is x+1,y+1. left is x-1,y+1. right is x+1,y-1.
	'bl': [Vector2(-3,1), Vector2(1, 7), Vector2(-1,11), Vector2(-6,14), Vector2(-10, 8), Vector2(-8,4), Vector2(-16,8), Vector2(-15,9), Vector2(-14,10), Vector2(-13, 11), Vector2(-12, 12), Vector2(-11,13), Vector2(-10,14), Vector2(-9,15), Vector2(-8,16), Vector2(-7,17), Vector2(-6,18), Vector2(-5,19)],
	'br': [Vector2(-1,-1), Vector2(0,-2), Vector2(1, -3), Vector2(-1,1), Vector2(3,3), Vector2(4,2), Vector2(5,1), Vector2(-5,19), Vector2(-4,18), Vector2(-3,17), Vector2(-2,16), Vector2(-1,15), Vector2(0,14), Vector2(1,13), Vector2(2,12), Vector2(3,11), Vector2(4,10), Vector2(5,9), Vector2(6,8), Vector2(7,7), Vector2(8,6), Vector2(9,5)],
	'tl': [Vector2(0,0), Vector2(1,-1), Vector2(2,-2), Vector2(0,2), Vector2(4,4), Vector2(5,3), Vector2(6,2), Vector2(-4,-4), Vector2(-3, -5), Vector2(-2, -6), Vector2(-5,-3), Vector2(-6,-2), Vector2(-7,-1), Vector2(-8,0), Vector2(-9,1), Vector2(-10,2), Vector2(-11,3), Vector2(-12,4), Vector2(-13,5), Vector2(-14,6), Vector2(-15,7), Vector2(-16, 8)],
	'tr': [Vector2(-4,2), Vector2(0,8), Vector2(-2,12), Vector2(-7,15), Vector2(-11,9), Vector2(-9,5), Vector2(9,5), Vector2(8,4), Vector2(7,3), Vector2(6,2), Vector2(5,1), Vector2(4,0), Vector2(3,-1), Vector2(2,-2), Vector2(1,-3), Vector2(0,-4), Vector2(-1,-5), Vector2(-2,-6)],
}

@onready var gears = {
	'left': [Vector2(-2,8), Vector2(-8,8)],
	'right': [Vector2(-5,5), Vector2(-5,11)],
}

@onready var conveyors = {
	'bl': [Vector2(-6,4), Vector2(-7,5), Vector2(-8,6), Vector2(-9,7)],
	'br': [Vector2(-9,9), Vector2(-8,10), Vector2(-7,11), Vector2(-6,12)],
	'turn_br': [Vector2(-10,8)],
	'turn_tr': [Vector2(-5,13)],
	'tr': [Vector2(-4,12), Vector2(-3,11), Vector2(-2,10), Vector2(-1,9)],
	'turn_tl': [Vector2(0,8)],
	'tl': [Vector2(-1,7), Vector2(-2,6), Vector2(-3,5), Vector2(-4,4)],
	'turn_bl': [Vector2(-5,3)],
}

@onready var pitfalls = [Vector2(-9,1), Vector2(-7,9), Vector2(-1,15), Vector2(-3,7)]

@onready var checkpoints = {
	'check1' : [Vector2(-7,13), $"Checkpoint 1/AnimationPlayer"],
	'check2' : [Vector2(-3,3), $"Checkpoint 2/AnimationPlayer"]
}

@onready var robot1 = $Robot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints['check1'][1].play('idle_1')
	checkpoints['check2'][1].play('idle_2')
	pass
	#robot.position = move_hammer(hammer_x, hammer_y)
	#change_idle()

func checking_checkpoint() -> void:
	var robot_pos = Vector2(robot1.robot_x, robot1.robot_y)
	
	if robot_pos == checkpoints['check1'][0]:
		if robot1.checkpoints == 0:
			robot1.checkpoints += 1
			print(robot1.character)
			print("new checkpoint reached! This robot has reached " + str(robot1.checkpoints) + " checkpoint(s)")
			checkpoints['check1'][1].play("hammerbot_check_1")
			
	elif robot_pos == checkpoints['check2'][0]:
		if robot1.checkpoints == 1:
			robot1.checkpoints += 1
			print("new checkpoint reached! This robot has reached " + str(robot1.checkpoints) + " checkpoint(s)")
			print(robot1.character)
			checkpoints['check2'][1].play("hammerbot_check_2")
			
	else:
		checkpoints['check1'][1].play("idle_1")
		checkpoints['check2'][1].play("idle_2")


#func change_idle() -> void:
	#hammer_animationPlayer.play(hammer_direction + "_idle")
#
## shuts down the robot: inputs will not work while shut down
#func shutdown() -> void:
	#if hammer_shutdown:
		#change_idle()
		#hammer_shutdown = false
	#else:
		#hammer_animationPlayer.play(hammer_direction + "_shutdown")
		#hammer_shutdown = true
#
## uses current direction of robot and turn input to turn in the correct direction
#func turn_hammer(dir) -> void:
	#if dir == 'left':
		#match hammer_direction:
			#'bl':
				#hammer_direction = 'br'
			#'br':
				#hammer_direction = 'tr'
			#'tr':
				#hammer_direction = 'tl'
			#'tl':
				#hammer_direction = 'bl'
			#_:
				#print('BAD DIRECTION, NOT REAL')
	#else:
		#match hammer_direction:
			#'bl':
				#hammer_direction = 'tl'
			#'tl':
				#hammer_direction = 'tr'
			#'tr':
				#hammer_direction = 'br'
			#'br':
				#hammer_direction = 'bl'
			#_:
				#print('BAD DIRECTION, NOT REAL')
	## restores idle
	#change_idle()

# moves the hammerbot on the board, uses the arrow keys
#func move_hammer(x, y) -> Vector2:
	#hammer_x = x
	#var hammer_pixel_x = x * (852 / 2)
	#hammer_y = y 
	#var hammer_pixel_y = y * (426 / 2)
	#return Vector2(hammer_pixel_x, hammer_pixel_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _unhandled_input(event: InputEvent) -> void:
	## For moving forward or backward from a card, can find the direction the robot
	## is facing and do that movement. movement side to side is included for the 
	## sake of the conveyor belts and pushing. My suggestion would be to have the 
	## robot moving into the space triggers the robot already moving to move out of 
	## the way, and if theres a wall blocking them then they never move at all.
	#
	#print("start on: " + str(hammer_x) + ", " + str(hammer_y))
	## check if shutdown, if so then no input will work except to exit shutdown
	#if hammer_shutdown:
		#if event.is_action_pressed("ui-shutdown"):
			#shutdown()
		#return
		#
	## MOVEMENT
	#if event.is_action_pressed("ui_up") && Vector2(hammer_x, hammer_y) not in walls['tl']:
		#var hammer_tween = create_tween()
		#hammer_tween.tween_property(robot, "position", move_hammer(hammer_x - 1, hammer_y - 1), 1)
	#elif event.is_action_pressed("ui_down") && Vector2(hammer_x, hammer_y) not in walls['br']:
		#var hammer_tween = create_tween()
		#hammer_tween.tween_property(robot, "position", move_hammer(hammer_x + 1, hammer_y + 1), 1)
	#elif event.is_action_pressed("ui_right") && Vector2(hammer_x, hammer_y) not in walls['tr']:
		#var hammer_tween = create_tween()
		#hammer_tween.tween_property(robot, "position", move_hammer(hammer_x + 1, hammer_y - 1), 1)
	#elif event.is_action_pressed("ui_left") && Vector2(hammer_x, hammer_y) not in walls['bl']:
		#var hammer_tween = create_tween()
		#hammer_tween.tween_property(robot, "position", move_hammer(hammer_x - 1, hammer_y + 1), 1)
		#
	## TURNING
	#elif event.is_action_pressed("ui-turn-left"):
		#turn_hammer('left')
	#elif event.is_action_pressed("ui-turn-right"):
		#turn_hammer('right')
		#
	## SHUTDOWN
	#elif event.is_action_pressed("ui-shutdown"):
		#shutdown()
		#
	## FIRE LASER To be added
	##elif event.is_action_pressed("ui-laser"):
		##hammer_animationPlayer.play(hammer_direction + "_laser")
	#print("now on: " + str(hammer_x) + ", " + str(hammer_y))
