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

func _on_robot_spawned(robot):
	robot1 = robot

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if robot1 == null:
		var maybe_robot = get_node_or_null("../Players/Robot")
		if maybe_robot != null:
			robot1 = maybe_robot
			print("Robot found!")
			robot1.connect("finished_movement", Callable(self, "checking_checkpoint"))
