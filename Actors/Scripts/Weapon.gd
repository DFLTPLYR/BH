extends Node2D

onready var limb = $hand
onready var weaponPos = $hand/Weapon
onready var spawnPos = $hand/Weapon/Position2D
onready var CastTimer = $Timer
onready var Reload = $Timer2
onready var ray = $hand/Weapon/RayCast2D

var item_shader = preload("res://Inventory/Resources/InventorySlotDisplay.tres").duplicate(false)

export (AudioStreamSample) var gun_shot_audio
export (AudioStreamSample) var reload_audio

export (Resource) var item = null

var target = null
var canCast = true
var max_mag

func _ready() -> void:
#	muzzleFlash.duplicate(false)
	add_to_group("Weapons")
	CastTimer.connect("timeout", self, "cooldown")
	Reload.connect("timeout", self, "reload_time")

	if item:
		load_stats()
		set_shader()

func _physics_process(delta: float) -> void:
	if !Signals.arrayEnemies.empty():
		var target_pos = Signals.arrayEnemies.front().global_position
		target = target_pos
		var target_rot = weaponPos.global_position.direction_to(target_pos).angle()
		rotation = lerp_angle(rotation, target_rot, item.rot_speed * delta)
	else:
		rotation = lerp_angle(rotation, 0.0, item.rot_speed * delta)
		target = null

	if canCast and target:
		if max_mag != 0:
			if ray.is_colliding():
				fire()
				Signals.play(gun_shot_audio, self.global_transform)
	
	elif max_mag == 0:
		canCast = false
		Reload.start()

func set_shader():
	weaponPos.material = item_shader
	if item.rarity == "legendary":
		weaponPos.material.set("shader_param/color", Color(0.85,0.48,0.5,1))
	if item.rarity == "epic":
		weaponPos.material.set("shader_param/color", Color(0.92,0.5,0.97,1))
	if item.rarity == "uncommon":
		weaponPos.material.set("shader_param/color", Color(0.15,0.20,0.98,1))
	if item.rarity == "common":
		weaponPos.material.set("shader_param/color", Color(0.79,0.80,0.94,1))
	if item.rarity == "shi - tier":
		weaponPos.material.set("shader_param/color", Color(1,1,1,1))

func load_stats():
	CastTimer.wait_time = item.firerate
	Reload.wait_time = item.reloadSpeed
	Reload.one_shot = true
	ray.cast_to.x = item.rayLOS
	max_mag = item.magazine

func fire():
	if canCast:
		max_mag -= 1
	#	bullets
		var instance = item.bullet_path.instance()
		instance.Damage = item.damage
	#	current scene
		var scene = get_tree().root
	#	adding fetus
		spawnPos.rotation_degrees = rand_range(item.BulletSpread, -item.BulletSpread)
		instance.transform = spawnPos.global_transform
		scene.call_deferred("add_child", instance)
		canCast = false
		CastTimer.start()

func cooldown() -> void:
	canCast = true

func reload_time() -> void:
	max_mag = item.magazine
	cooldown()
