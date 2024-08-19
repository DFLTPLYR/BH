extends KinematicBody2D

enum STATE {
	IDLE,
	ATTACK,
	MOVE
}

onready var sprite = $Sprite
onready var animations = $AnimationPlayer
onready var ray_cast_2d: RayCast2D = $RayCast2D

export (NodePath) onready var Health_Component = get_node(Health_Component) as Area2D
export (NodePath) onready var HurtBox_Component = get_node(HurtBox_Component) as Area2D


export var Health:float
export var Damage:int
export var SPEED:int

var velocity = Vector2.ZERO
var dir = Vector2.ZERO
var target = null

var state = STATE.MOVE

func _ready() -> void:
	add_to_group("Enemies")
	animations.connect("animation_finished", self, "anim_end")
	Health_Component.connect("damage_dealt", self, "take_hit")
	rand_stats()

func _physics_process(delta: float) -> void:
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	match state:
		STATE.MOVE:
			move_state(delta)
		STATE.ATTACK:
			attack_state()
		STATE.IDLE:
			idle_state()

func rand_stats():
	randomize()
	var chance = ShopItems.rng.randi_range(1,100)
	if chance >= 90:
		Damage += Signals.difficulty * Damage
		Health += Signals.difficulty * Health
		SPEED += Signals.difficulty * SPEED
	if chance >= 80:
		Health += Signals.difficulty * Health
		SPEED += Signals.difficulty * SPEED
	if chance >= 40:
		SPEED += Signals.difficulty * SPEED
	if chance >= 1:
		Health += Signals.difficulty * Health

func move_state(delta):
	animations.play("walk")
	if Signals.player_pos:
		dir = global_position.direction_to(Signals.player_pos)
		velocity = dir * SPEED
		velocity = velocity.move_toward(dir * SPEED,delta)
		velocity = move_and_slide(velocity)

		ray_cast_2d.look_at(Signals.player_pos)
		
		if ray_cast_2d.is_colliding():
			var collider = ray_cast_2d.get_collider()
			if collider.has_method("take_damage"):
				state = STATE.ATTACK

func attack_state():
	animations.play("attack")

func idle_state():
	state = STATE.IDLE

func take_hit(value):
	Health -= value
	if Health <= 0:
		death()

func anim_end(a: String):
	if a == "attack":
		state = STATE.MOVE
	if a == "death":
		var child = load("res://Actors/Pickables/Shard.tscn") as PackedScene
		child = child.instance()
		var scene = get_tree().root
		child.transform = global_transform
		scene.call_deferred("add_child", child)
		self.queue_free()

func death():
	state = STATE.IDLE
	Health_Component.set_deferred("monitorable", false)
	animations.play("death")
