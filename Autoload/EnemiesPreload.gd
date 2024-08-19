extends Node

signal tiles_ready
signal next_wave
#shader
onready var queue_free_shader = preload("res://Assests/disintegrate.tres")

onready var blackSmith = preload("res://Actors/neutral/Blacksmith.tscn")
onready var spawn_anim = preload("res://Actors/neutral/Spawn_animation.tscn")

var _melee = load("res://Actors/Enemies/melee_enemy.tscn")
var _range = load("res://Actors/Enemies/basic_range.tscn")

var powerItems = preload("res://Actors/neutral/Power_Up.tscn")

var SAFE_RANGE = 0

var avail_tile = null
var parent_spawn = null

var tilesCoords = []
var vendors = []
var drops = []

onready var Enemies = [_range, _melee]

func _ready() -> void:
	connect("tiles_ready", self, "player_ready")
	connect("next_wave", self, "remove_vendors")
	Signals.connect("restart", self, "reset")

func player_ready():
	SAFE_RANGE += Signals.player_Selected.safe_range
	avail_tile = get_node("/root/World/inside")
	var tiles:Array = avail_tile.get_used_cells_by_id(3)
	tilesCoords.append(tiles)

func reset():
	ShopItems.value = 0
	for i in vendors.size():
		if is_instance_valid(vendors[i]):
			vendors[i].queue_free()

func spawn_merchant():
	randomize()

	var point = Position2D.new()
	point.position = Signals.player_pos + Vector2(200, 0).rotated(rand_range(0, TAU))

	var local_position = avail_tile.to_local(point.position)
	var map_position = avail_tile.world_to_map(local_position)
	
	if tilesCoords[0].has(map_position):
		var merchants = [blackSmith]
		var value = ShopItems.rng.randi_range(1, merchants.size())
		for i in value:
			var merchant = merchants[i].instance()
			merchant.position = point.position
			vendors.append(merchant)
			call_deferred("add_child", merchant)
	else:
		return spawn_merchant()

func SpawnMobs():
	randomize()
	if is_instance_valid(Signals.player_Selected):
		var point = Position2D.new()
		point.position = Signals.player_pos + Vector2(SAFE_RANGE, 0).rotated(rand_range(0, TAU))

		var local_position = avail_tile.to_local(point.position)
		var map_position = avail_tile.world_to_map(local_position)

		if tilesCoords[0].has(map_position):
			var spawn_point = spawn_anim.instance()
			var enemy_variant = EnemiesPreload.Enemies[randi() % EnemiesPreload.Enemies.size()]
			spawn_point.child = enemy_variant.instance()
			spawn_point.position = point.position
			spawn_point.location = parent_spawn
			parent_spawn.call_deferred("add_child", spawn_point)
		else:
			return SpawnMobs()

func cluster_spawn():
	randomize()
	if Signals.player_Selected:
		if avail_tile:
			var point = Position2D.new()
			point.position = Signals.player_pos + Vector2(SAFE_RANGE, 0).rotated(rand_range(0, TAU))

			var local_position = avail_tile.to_local(point.position)
			var map_position = avail_tile.world_to_map(local_position)

			if tilesCoords[0].has(map_position):
				for i in ShopItems.rng.randi_range(1, 5):
					var spawn_point = spawn_anim.instance()
					var enemy_variant = Enemies[randi() % Enemies.size()]
					spawn_point.child = enemy_variant.instance()
					spawn_point.location = parent_spawn

					spawn_point.position = point.position + Vector2(30, 0).rotated(rand_range(0, TAU))

					var l_pos = avail_tile.to_local(spawn_point.position)
					var m_pos = avail_tile.world_to_map(l_pos)

					if tilesCoords[0].has(m_pos):
						parent_spawn.call_deferred("add_child", spawn_point)
					else:
						return

func random_power_item_spawn(value):
	randomize()
	var item_count = value
	if is_instance_valid(Signals.player_Selected):
		for i in item_count:
			var spawn_point = PowerUp.new()
			spawn_point.child = powerItems
			spawn_point.location = parent_spawn

			spawn_point.position = Signals.player_Selected.position + Vector2(200, 0).rotated(rand_range(0, TAU))

			var l_pos = avail_tile.to_local(spawn_point.position)
			var m_pos = avail_tile.world_to_map(l_pos)

			if tilesCoords[0].has(m_pos):
				parent_spawn.call_deferred("add_child", spawn_point)
			else:
				return
