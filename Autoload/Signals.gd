extends Node

signal player_Position(playerPos)
signal current_wave_time(value)
signal dead
signal wave_End
signal wave_Start
signal ready_World
signal restart

var arrayEnemies = []

var viewport_priority = null
var global_wave_timer = null
var wave_spawner_timer = null

var examples = null

var player_Selected = null
var cam_tween = null
var camera = null
var player_pos = null

onready var wave = 1

onready var wave_timer = 20
onready var difficulty = 0.25

#damage Effect
var damageText = preload("res://Actors/DamageText.tscn")
var death_screen = preload("res://Menu/death_Screen.tscn")

func _init() -> void:
	create_timer()

	var priority = RemoteTransform2D.new()
	viewport_priority = priority
	viewport_priority.name = "camera_focus"
	call_deferred("add_child", viewport_priority)
 
func _ready() -> void:
	connect("wave_Start", self, "resume")
	connect("dead", self, "player_dead")
	connect("player_Position", self, "selected_pos")
	connect("restart", self, "reset")

func reset():
	wave = 1
	wave_timer = 20
	ShopItems.currency = 0
	ShopItems.value = 0
	create_timer()
	return

func create_timer():
	var wave_timer = Timer.new()
	global_wave_timer = wave_timer
	add_child(global_wave_timer)
	global_wave_timer.connect("timeout", self, "wave_Ended")
#	global_wave_timer.wait_time = 1
#	global_wave_timer.autostart = true
#	global_wave_timer.paused = true

	var spawner_timer = Timer.new()
	wave_spawner_timer = spawner_timer
	add_child(wave_spawner_timer)
	wave_spawner_timer.connect("timeout", self, "check_wave_timer")
#	wave_spawner_timer.autostart = true
#	global_wave_timer.paused = true
#	wave_spawner_timer.wait_time = 1.5

func selected_pos(pos: Vector2):
	player_pos = pos

func resume():
	global_wave_timer.start(wave_timer)
	wave_spawner_timer.start(1.75)
	emit_signal("current_wave_time", wave_timer)

func check_wave_timer():
	if !global_wave_timer.is_stopped():
		var chance_spawn = ShopItems.rng.randi_range(1,100)
		if chance_spawn <= 50:
			EnemiesPreload.SpawnMobs()
		elif chance_spawn >= 51:
			EnemiesPreload.cluster_spawn()
	else:
		return

func wave_Ended():
	var roll_chance = ShopItems.rng.randi_range(1,100)
	var value = 0
	if roll_chance >= 80:
		value = 4
	elif roll_chance >= 60:
		value = 3
	elif roll_chance >= 40:
		value = 2
	elif roll_chance >= 20:
		value = 1
	else:
		value = 0
	if is_instance_valid(player_Selected):
		global_wave_timer.stop()
		wave += 1
		difficulty_scaling()
		EnemiesPreload.spawn_merchant()
#		EnemiesPreload.random_power_item_spawn(value)
		

func difficulty_scaling():
	var add_time = wave_timer * difficulty
	wave_timer = wave_timer + add_time
	global_wave_timer.wait_time = wave_timer
	return global_wave_timer

func player_dead():
	global_wave_timer.paused = true
	wave_spawner_timer.paused = true
	player_Selected.get_parent().remove_child(player_Selected)
	player_Selected = null
	var child = death_screen.instance()
	add_child(child)
	wave_spawner_timer.queue_free()
	global_wave_timer.queue_free()

func damage_text(parent: Object, value):
	var child = damageText.instance()
	child.amount = value
	parent.add_child(child)

func sortArray(a, b):
	if player_pos:
		if a.position.distance_to(player_pos) >= b.position.distance_to(player_pos):
			return a < b
		else:
			return a > b

func play(audio_file: AudioStreamSample, pos: Transform2D):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.bus = "Effects"
	audio_player.duplicate(false)
	audio_player.connect("finished", audio_player, "queue_free")
	audio_player.stream = audio_file
	audio_player.transform = pos
	call_deferred("add_child", audio_player)
	audio_player.play()

func play_Theme(audio_file: AudioStreamOGGVorbis, parent):
	var audio_player = AudioStreamPlayer.new()
	audio_player.bus = "Themes"
	audio_player.duplicate(false)
	audio_player.connect("tree_exited", audio_player, "queue_free")
	audio_player.stream = audio_file
	parent.call_deferred("add_child", audio_player)
	audio_player.play()

func change_camera(focus, zoom, ease_time):
	if viewport_priority:
		viewport_priority.get_parent().call_deferred("remove_child", viewport_priority)
		focus.call_deferred("add_child", viewport_priority)
		if camera and viewport_priority:
			viewport_priority.remote_path = camera.get_path()
			if cam_tween and viewport_priority:
				tween_cam(zoom, ease_time)
	else:
		pass

func tween_cam(zoom, ease_time):
	if cam_tween:
		cam_tween.interpolate_property(Signals.camera, "zoom", Signals.camera.zoom, zoom, ease_time)
		cam_tween.start()

func quit():
	get_tree().quit()
