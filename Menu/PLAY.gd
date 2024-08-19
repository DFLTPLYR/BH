extends Button

onready var spawnpoint = $"../../Position2D"
onready var animate = $"../../AnimationPlayer"
onready var door =  $"../../HauntedHouse/Area2D"
onready var prev = $"../../ChangeCharacter/prev"
onready var next = $"../../ChangeCharacter/next"
onready var trees = [$"../../BgTilesObjects/Position2D",$"../../BgTilesObjects/Position2D2",$"../../BgTilesObjects/Position2D3",$"../../BgTilesObjects/Position2D4"]
onready var change_character: GridContainer = $"../../ChangeCharacter"
onready var char_profile: PanelContainer = $"../../char_profile"
onready var profile_icon: TextureRect = $"../../char_profile/profile_icon"
onready var settings: CanvasLayer = $"../../Settings"

var thunder_sound = preload("res://Sounds/Ambience/Thunder Sound effect.ogg")
var characters = [load("res://Actors/Player/Crow.tscn"), load("res://Actors/Player/Test.tscn")]
var lightning = preload("res://Actors/neutral/Lightning.tscn")
var fire = preload("res://Actors/neutral/fire.tscn").duplicate(false)
var location = preload("res://World/World.tscn").instance()

var playerSelected = null
var spawn_point_location = null
var index = 0
var entered = false

func _ready() -> void:
	randomize()
	char_profile.visible = false
	change_character.visible = false
	spawn_point_location = spawnpoint.global_transform

	connect("button_up", self, "disable")

	next.connect("button_up", self, "next")
	prev.connect("button_up", self, "prev")

	door.connect("area_entered", self, "link")
	animate.connect("animation_finished", self, "anim_End")

func anim_End(anim_name: String):
	if anim_name == "strike":
		animate.play("start")
		Signals.play_Theme(thunder_sound, spawnpoint)
		add_fire()
		spawn_Character()
	if anim_name == "lightning_strike":
		var child = lightning.instance()
		child.transform = spawn_point_location
		spawnpoint.call_deferred("add_child", child)
	if anim_name == "loading":
		Signals.player_Selected = playerSelected
		$"../../HauntedHouse/Area2D/CollisionShape2D".set_deferred("disabled", true)
		$"../..".remove_child(settings)
		get_node("/root").call_deferred("add_child", location)
		location.call_deferred("add_child",settings)
		$"../..".queue_free()

func add_fire():
	var scene = get_tree().current_scene
	var i = randi() % 4
	var spark = fire.instance()
	var point = Position2D.new()
	point.position = trees[i].position + Vector2(ShopItems.rng.randi_range(1,20), 0).rotated(rand_range(0, TAU))
	spark.position = point.position
	scene.call_deferred("add_child", spark)

# warning-ignore:function_conflicts_variable
func next():
	if playerSelected:
		if index == characters.size() - 1:
			pass
		else:
			index += 1
			spawn_point_location = playerSelected.global_transform
			playerSelected.queue_free()
			playerSelected = null
			animate.play("lightning_strike")

# warning-ignore:function_conflicts_variable
func prev():
	if playerSelected:
		if index == 0:
			index = 0
		else:
			index -= 1
			spawn_point_location = playerSelected.global_transform
			playerSelected.queue_free()
			playerSelected = null
			animate.play("lightning_strike")

func spawn_Character():
	var scene = get_tree().root
	if !playerSelected:
		var character = characters[index]
		character = character.instance()
		profile_icon.texture = character.picture
		playerSelected = character
		character.transform = spawn_point_location
		scene.call_deferred("add_child", character)
		char_profile.visible = true

func link(Body: Area2D):
	if Body.get_parent().is_in_group("Player") and !Signals.player_Selected:
		animate.play("loading")

func disable():
	self.visible = false
	$"../QUIT".visible = false
	change_character.visible = true
	animate.play("lightning_strike")
