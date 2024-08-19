extends KinematicBody2D

onready var body = $Sprite


export var Health = 50.0
export (Texture) var picture
export (Resource) var Inventory_Resource
export (PackedScene) var Gun_Positions
export (PackedScene) var Light_Source
export (Vector2) var eye_sight
export (int) var safe_range
export (int) var speed = 0

var max_health = null
var target_regen
var velocity = Vector2.ZERO
var regeneration = false
var regen_stop = true

func _init() -> void:
	add_to_group("Player")

func regen_status():
	regen_stop = false
	regeneration = false

func movement():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Input.get_axis("ui_left","ui_right")
	velocity = input_direction * speed
	if velocity.x < 0:
		body.flip_h = true
	elif velocity.x > 0:
		body.flip_h = false
	move_and_slide(velocity)

# warning-ignore:unused_argument
func _physics_process(delta):
	movement()

