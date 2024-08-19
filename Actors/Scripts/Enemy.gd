extends KinematicBody2D

enum {
	MOVE,
	ATTACK,
	IDLE
}

var STATE = IDLE

export (float) var Health = 50.0
export (int) var ACCELERATION = 300
export (int) var MAX_SPEED = 50
export (float) var Attack = 40

var velocity = Vector2.ZERO
var target = null

onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var animate = $Animation
onready var attack_box = $RayCast2D/Area2D
onready var timer = $Timer

func _ready() -> void:

# warning-ignore:return_value_discarded
	Signals.connect("player_Position", self, "player_position")
	$RayCast2D/Area2D/CollisionShape2D.disabled = true
	add_to_group("Enemies")

func _physics_process(delta: float) -> void:
	if STATE == MOVE and Signals.player_Selected:
		raycast.look_at(Signals.player_pos)
		accelerate_towards(Signals.player_pos, delta)
		if raycast.is_colliding():
			STATE = ATTACK
	if STATE == ATTACK:
		animate.play("attack")

func accelerate_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func death():
	var child = load("res://Actors/Pickables/Shard.tscn") as PackedScene
	child = child.instance()
	var scene = get_tree().root
	child.transform = global_transform
	scene.call_deferred("add_child", child)
	queue_free()

func attack(body: KinematicBody2D):
	body.hit(Attack)

func hit(damage):
	Health -= damage
	var d_text = Signals.damageText.instance()
	d_text.amount = damage
	add_child(d_text)
	if Health <= 0:
		death()

