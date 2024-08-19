extends Area2D

signal enemy
signal enemy_null


onready var spawnPos = $"../Node2D/Sprite/RayCast2D/Position2D"
onready var ray = $"../Node2D/Sprite/RayCast2D"
onready var castTimer = $"../Timer"


export var attack = 50.0

var target = null
var castOn = true

func _ready() -> void:
	$".".connect("area_entered", self, "target_found")
	$".".connect("area_exited", self, "target_lost")
	castTimer.connect("timeout", self, "castoff")
	castTimer.wait_time = 3

func castoff():
	castOn = true

func _physics_process(delta: float) -> void:
	if target:
		var target_pos = target.global_position
		var target_rot = ray.global_position.direction_to(target_pos).angle()
		$"../Node2D".rotation = lerp_angle($"../Node2D".rotation, target_rot, 100 * delta)
	if ray.is_colliding() and castOn:
		castTimer.start()
		fire()

func fire():
	var bullet = load("res://Actors/Projectiles/Enemy_dark_bullet.tscn") as PackedScene
	var bullet_Instance = bullet.instance()
	var scene = get_tree().root
	bullet_Instance.damage = attack
	bullet_Instance.transform = spawnPos.global_transform
	scene.call_deferred("add_child", bullet_Instance)
	castOn = false

func target_found(area: Area2D):
	target = area
	emit_signal("enemy")

func target_lost(_area: Area2D):
	target = null
	emit_signal("enemy_null")

