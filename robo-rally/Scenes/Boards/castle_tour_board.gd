extends Node2D

const ORIGIN = Vector2(1235.0, -1650.0)
const PIXEL_X = (852 / 2)
const PIXEL_Y = (426 / 2)
const STARTING_POSITIONS = [Vector2(0,0), Vector2(1,1), Vector2(2,2), Vector2(3,3)]

const SPRITE_SCALE = {"Twonky" : Vector2(0.4,0.4),
					  "HammerBot" : Vector2(0.3,0.3)}

@onready var robot : CharacterBody2D = $Robot
@onready var p1cam : Camera2D = $Robot/P1Camera

#startinglocation_x = (grid_x - grid_y) * (tile_width / 2)
#startinglocation_y = (grid_x + grid_y) * (tile_height / 2)

#@onready var hammer_x = 0
#@onready var hammer_y = 0
#@onready var hammer_direction = "bl"
#@onready var hammer_shutdown = false
#
#@onready var hammer_animationPlayer : AnimationPlayer = $Robot/Sprite2D/AnimationPlayer

@onready var walls = { # start space is (0,0). up is x-1,y-1. down is x+1,y+1. left is x-1,y+1. right is x+1,y-1.
	'bl': [],
	'br': [],
	'tl': [],
	'tr': [],
}

@onready var gears = {
	'left': [],
	'right': [],
}

@onready var batteries = []

@onready var conveyors = {
	'bl': [],
	'turn_bl-br': [],
	'turn_bl-tl': [],
	'br': [],
	'turn_br-bl': [],
	'turn_br-tr': [],
	'tr': [],
	'turn_tr-tl': [],
	'turn_tr-br': [],
	'tl': [],
	'turn_tl-tr': [],
	'turn_tl-bl': [],
}

@onready var double_conveyors = {
	'bl': [],
	'turn_bl-br': [],
	'turn_bl-tl': [],
	'br': [],
	'turn_br-bl': [],
	'turn_br-tr': [],
	'tr': [],
	'turn_tr-tl': [],
	'turn_tr-br': [],
	'tl': [],
	'turn_tl-tr': [],
	'turn_tl-bl': [],
}

@onready var lasers = []

@onready var starts = [Vector2(0.0,0.0), Vector2(1.0,1.0), Vector2(2.0,2.0), Vector2(3.0,3.0)]

@onready var pitfalls = []

@onready var checkpoints = {
	'check1' : [Vector2(-7.0,13.0), $"Checkpoint 1/AnimationPlayer"],
	'check2' : [Vector2(0.0,2.0), $"Checkpoint 2/AnimationPlayer"]
}

var robot1 : Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoints['check1'][1].play('idle_1')
	checkpoints['check2'][1].play('idle_2')
	#robot.position = move_hammer(hammer_x, hammer_y)
	#change_idle()


func _on_robot_spawned(robot):
	robot1 = robot

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
	#var hammer_pixel_x = x * (852 / 2) + ORIGIN.x
	#hammer_y = y 
	#var hammer_pixel_y = y * (426 / 2) + ORIGIN.y
	#return Vector2(hammer_pixel_x, hammer_pixel_y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if robot1 == null:
		var maybe_robot = get_node_or_null("../Players/Robot")
		if maybe_robot != null:
			robot1 = maybe_robot
			print("Robot found!")
			robot1.connect("finished_movement", Callable(self, "checking_checkpoint"))

#func _unhandled_input(event: InputEvent) -> void:
	# For moving forward or backward from a card, can find the direction the robot
	# is facing and do that movement. movement side to side is included for the 
	# sake of the conveyor belts and pushing. My suggestion would be to have the 
	# robot moving into the space triggers the robot already moving to move out of 
	# the way, and if theres a wall blocking them then they never move at all.
	
	#print("start on: " + str(hammer_x) + ", " + str(hammer_y))
	# check if shutdown, if so then no input will work except to exit shutdown
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
		
	# FIRE LASER To be added
	#elif event.is_action_pressed("ui-laser"):
		#hammer_animationPlayer.play(hammer_direction + "_laser")
	#print("now on: " + str(hammer_x) + ", " + str(hammer_y))
