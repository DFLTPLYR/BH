extends Node2D

onready var root = get_tree().get_root()
var player = null
var starter_gun = preload("res://World/weapon_starter.tscn").instance()

func _ready() -> void:
	player = Signals.player_Selected
	Spawn()
	connect("ready", EnemiesPreload,"player_ready")

func Spawn():
	randomize()
	get_tree().root.call_deferred("remove_child", player)
	$"..".call_deferred("add_child", player)
	$"..".call_deferred("add_child", starter_gun)
	player.transform = global_transform
	starter_gun.position = player.global_position + Vector2(0, -100).rotated(TAU)
	self.queue_free()
