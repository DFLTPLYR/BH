extends KinematicBody2D

enum STATE{
	WALK,
	DASH,
	IDLE
}

export (NodePath) onready var Health_Component = get_node(Health_Component) as Area2D
export (NodePath) onready var HurtBox_Component = get_node(HurtBox_Component) as Area2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var raycast_2d: RayCast2D = $Raycast2D
onready var sprite: Sprite = $Sprite

export var Health:float
export var Damage:float
export var SPEED:int
export var DASH_SPEED:int

var velocity = Vector2.ZERO
var dir = Vector2.ZERO
var target = null

var state = STATE.IDLE

func _ready() -> void:
	Signals.connect("player_Position", self, "target_pos")
	Health_Component.connect("damage_dealt", self, "take_hit")

func _process(delta: float) -> void:
	
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	match state:
		STATE.WALK:
			animation_player.play("Walking")
			walk_state()
		STATE.DASH:
			animation_player.play("Charge")
		STATE.IDLE:
			animation_player.play("Idle")
	
	velocity = move_and_slide(velocity)

func target_pos(player: Vector2):
	target = player

func walk_state():
	dir = position.direction_to(Signals.player_Selected.global_position)
	velocity = dir * SPEED
	
	raycast_2d.look_at(Signals.player_Selected)
	if raycast_2d.is_colliding():
		var cast = raycast_2d.get_collider()
		if cast is Node:
			if cast.is_in_group("Player"):
				dash_state()

func dash_state():
	dir = position.direction_to(target)
	velocity = dir * DASH_SPEED
	state = STATE.DASH

	var time = Timer.new()
	add_child(time)
	time.start()
	time.connect("timeout", self, "idle_state")
	time.connect("timeout", time, "queue_free")

func idle_state():
	dir = Vector2.ZERO
	state = STATE.IDLE
	
	if !Health <= 0:
		var time = Timer.new()
		add_child(time)
		time.start(0.5)
		time.connect("timeout", self, "walk_state")
		time.connect("timeout", time, "queue_free")

func take_hit(value):
	Health -= value
	var d_text = Signals.damageText.instance()
	var scene = get_tree().root
	d_text.amount = value
	d_text.transform = global_transform
	scene.call_deferred("add_child", d_text)
	if Health <= 0:
		state = STATE.IDLE
		death()

func death():
	var child = load("res://Actors/Pickables/Shard.tscn") as PackedScene
	child = child.instance()
	var scene = get_tree().root
	child.transform = global_transform
	scene.call_deferred("add_child", child)
	queue_free()
