extends Node2D

const ORIGIN = Vector2(1235.0, -1750.0)
const PIXEL_X = (852 / 2)
const PIXEL_Y = (426 / 2)
const STARTING_POSITIONS = [Vector2(0,0), Vector2(1,1), Vector2(2,2), Vector2(3,3)]

const SPRITE_SCALE = {
					  "Twonky" : Vector2(1.0,1.0),
					  "HammerBot" : Vector2(0.8,0.8),
					  # "SpinBot" : Vector2(0,0)
					}

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

#@onready var walls = { # start space is (0,0). up is x-1,y-1. down is x+1,y+1. left is x-1,y+1. right is x+1,y-1.
	#'bl': [Vector2(-3,1), Vector2(1, 7), Vector2(-1,11), Vector2(-6,14), Vector2(-10, 8), Vector2(-8,4)],
	#'br': [Vector2(-1,-1), Vector2(0,-2), Vector2(1,-3), Vector2(-1,1), Vector2(3,3), Vector2(4,2), Vector2(5,1)],
	#'tl': [Vector2(0,0), Vector2(1,-1), Vector2(2,-2), Vector2(0,2), Vector2(4,4), Vector2(5,3), Vector2(6,2)],
	#'tr': [Vector2(-4,2), Vector2(0,8), Vector2(-2,12), Vector2(-7,13), Vector2(-11,9), Vector2(-9,5)],
#}

@onready var walls = {Game.wall_key(Vector2(-3,1),Vector2(-4,2)):true,Game.wall_key(Vector2(1,7),Vector2(0,8)):true,
					  Game.wall_key(Vector2(-10,8),Vector2(-11,9)):true,Game.wall_key(Vector2(-6,14),Vector2(-7,15)):true,
					  Game.wall_key(Vector2(-1,-1),Vector2(0,0)):true,Game.wall_key(Vector2(0,-2),Vector2(1,-1)):true,
					  Game.wall_key(Vector2(1,-3),Vector2(2,-2)):true,Game.wall_key(Vector2(-1,1),Vector2(0,2)):true,
					  Game.wall_key(Vector2(3,3),Vector2(4,4)):true,Game.wall_key(Vector2(4,2),Vector2(5,3)):true,
					  Game.wall_key(Vector2(5,1),Vector2(6,2)):true, Game.wall_key(Vector2(2,-2),Vector2(3,-3)):true,
					  Game.wall_key(Vector2(3,-1),Vector2(4,-2)):true, Game.wall_key(Vector2(4,0),Vector2(5,-1)):true,
					  Game.wall_key(Vector2(5,1),Vector2(6,0)):true, Game.wall_key(Vector2(6,2),Vector2(7,1)):true,
					  Game.wall_key(Vector2(7,3),Vector2(8,2)):true, Game.wall_key(Vector2(8,4),Vector2(9,3)):true,
					  Game.wall_key(Vector2(9,5),Vector2(10,4)):true, Game.wall_key(Vector2(1,-3),Vector2(2,-4)):true,
					  Game.wall_key(Vector2(0,-4),Vector2(1,-5)):true, Game.wall_key(Vector2(-1,-5),Vector2(0,-6)):true,
					  Game.wall_key(Vector2(-2,-6),Vector2(-1,-7)):true, Game.wall_key(Vector2(-2,-6),Vector2(-3,-7)):true,
					  Game.wall_key(Vector2(-3,-5),Vector2(-4,-6)):true, Game.wall_key(Vector2(-4,-4),Vector2(-5,-5)):true,
					  Game.wall_key(Vector2(-5,-3), Vector2(-6,-4)):true, Game.wall_key(Vector2(-6,-2),Vector2(-7,-3)):true,
					  Game.wall_key(Vector2(-7,-1),Vector2(-8,-2)):true, Game.wall_key(Vector2(-8,0),Vector2(-9,-1)):true,
					  Game.wall_key(Vector2(-9,1),Vector2(-10,0)):true, Game.wall_key(Vector2(-10,2),Vector2(-11,1)):true,
					  Game.wall_key(Vector2(-11,3),Vector2(-12,2)):true, Game.wall_key(Vector2(-12,4),Vector2(-13,3)):true,
					  Game.wall_key(Vector2(-13,5),Vector2(-14,4)):true, Game.wall_key(Vector2(-14,6),Vector2(-15,5)):true,
					  Game.wall_key(Vector2(-15,7),Vector2(-16,6)):true, Game.wall_key(Vector2(-16,8),Vector2(-17,7)):true,
					  Game.wall_key(Vector2(-16,8),Vector2(-17,9)):true, Game.wall_key(Vector2(-15,9),Vector2(-16,10)):true,
					  Game.wall_key(Vector2(-14,10),Vector2(-15,11)):true, Game.wall_key(Vector2(-13,11),Vector2(-14,12)):true,
					  Game.wall_key(Vector2(-12,12),Vector2(-13,13)):true, Game.wall_key(Vector2(-11,13),Vector2(-12,14)):true,
					  Game.wall_key(Vector2(-10,14),Vector2(-11,15)):true, Game.wall_key(Vector2(-9,15),Vector2(-10,16)):true,
					  Game.wall_key(Vector2(-8,16),Vector2(-9,17)):true, Game.wall_key(Vector2(-7,17),Vector2(-8,18)):true,
					  Game.wall_key(Vector2(-6,18),Vector2(-7,19)):true, Game.wall_key(Vector2(-5,19),Vector2(-6,20)):true,
					  Game.wall_key(Vector2(-5,19),Vector2(-4,20)):true, Game.wall_key(Vector2(-4,18),Vector2(-3,19)):true,
					  Game.wall_key(Vector2(-3,17),Vector2(-2,18)):true, Game.wall_key(Vector2(-2,16),Vector2(-1,17)):true,
					  Game.wall_key(Vector2(-1,15),Vector2(0,16)):true, Game.wall_key(Vector2(0,14),Vector2(1,15)):true,
					  Game.wall_key(Vector2(1,13),Vector2(2,14)):true, Game.wall_key(Vector2(2,12),Vector2(3,13)):true,
					  Game.wall_key(Vector2(3,11),Vector2(4,12)):true, Game.wall_key(Vector2(4,10),Vector2(5,11)):true,
					  Game.wall_key(Vector2(5,9),Vector2(6,10)):true, Game.wall_key(Vector2(6,8),Vector2(7,9)):true,
					  Game.wall_key(Vector2(7,7),Vector2(8,8)):true, Game.wall_key(Vector2(8,6),Vector2(9,7)):true,
					  Game.wall_key(Vector2(9,5),Vector2(10,6)):true
					}

@onready var gears = {
	'left': [Vector2(-2,8), Vector2(-8,8)],
	'right': [Vector2(-5,5), Vector2(-5,11)],
}

@onready var batteries = [Vector2(2,8), Vector2(-5,15), Vector2(-12,8), Vector2(-5,1)]

@onready var single_conveyors = {
	'bl': [Vector2(-6,0), Vector2(-7,1), Vector2(-8,2), Vector2(-11,5), Vector2(-12,6), Vector2(-13,7)],
	'turn_bl-br': [Vector2(-14,8)],
	'turn_bl-tl': [Vector2(-9,3)],
	'br': [Vector2(-11,3), Vector2(-13,9), Vector2(-12,10), Vector2(-11,11), Vector2(-10,12), Vector2(-9,13), Vector2(-8,14), Vector2(-7,15), Vector2(-6,16), Vector2(0,14)],
	'turn_br-bl': [Vector2(-10,4)],
	'turn_br-tr': [Vector2(-5,17)],
	'tr': [Vector2(-4,16), Vector2(-3,15), Vector2(-2,14), Vector2(1,11), Vector2(2,10), Vector2(3,9)],
	'turn_tr-tl': [Vector2(4,8)],
	'turn_tr-br': [Vector2(-1,13)],
	'tl': [Vector2(-4,0), Vector2(-3,1), Vector2(-2,2), Vector2(-1,3), Vector2(0,4), Vector2(1,5), Vector2(2,6), Vector2(3,7), Vector2(-10,2), Vector2(1,13)],
	'turn_tl-tr': [Vector2(0,12)],
	'turn_tl-bl': [Vector2(-5,-1)],
}

@onready var double_conveyors = {
	'bl': [Vector2(-1,9), Vector2(-2,10), Vector2(-3,11), Vector2(-4,12)],
	'turn_bl-br': [],
	'turn_bl-tl': [Vector2(-5,13)],
	'br': [Vector2(-4,4), Vector2(-3,5), Vector2(-2,6), Vector2(-1,7)],
	'turn_br-bl': [Vector2(0,8)],
	'turn_br-tr': [],
	'tr': [Vector2(-9,7), Vector2(-8,6), Vector2(-7,5), Vector2(-6,4)],
	'turn_tr-tl': [],
	'turn_tr-br': [Vector2(-5,3)],
	'tl': [Vector2(-6,12), Vector2(-7,11), Vector2(-8,10), Vector2(-9,9)],
	'turn_tl-tr': [Vector2(-10,8)],
	'turn_tl-bl': [],
}

@onready var lasers = [
	Vector2(0,8), Vector2(-1,9), Vector2(-2,10), Vector2(-3,11), Vector2(-4,12), Vector2(-5,13), Vector2(-6,14),
	Vector2(-4,2), Vector2(-5,3), Vector2(-6,4), Vector2(-7,5), Vector2(-8,6), Vector2(-9,7), Vector2(-10,8)
]

@onready var pitfalls = [Vector2(-3,7), Vector2(-1,15), Vector2(-9,1), Vector2(-7,9)]

@onready var checkpoints = {Vector2(-7.0,13.0) : $"Walls/Checkpoint 1/AnimationPlayer",
							Vector2(0.0,2.0) : $"Walls/Checkpoint 2/AnimationPlayer"}

var robot1 : Sprite2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(checkpoints.values())):
		checkpoints.values()[i].play("idle_" + str(i + 1))
	#robot.position = move_hammer(hammer_x, hammer_y)
	#change_idle()
#
#func wall_key(a: Vector2, b: Vector2) -> String:
	## Convert to a format like "x1,y1|x2,y2" and sort so order doesn't matter
	#var A = "%s,%s" % [a.x, a.y]
	#var B = "%s,%s" % [b.x, b.y]
	#return A + "|" + B if A < B else B + "|" + A

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
# func move_hammer(x, y) -> Vector2:
	# hammer_x = x
	# var hammer_pixel_x = x * (852 / 2) + ORIGIN.x
	# hammer_y = y 
	# var hammer_pixel_y = y * (426 / 2) + ORIGIN.y
	# return Vector2(hammer_pixel_x, hammer_pixel_y)

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
