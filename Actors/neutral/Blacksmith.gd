extends KinematicBody2D

signal player_inventory_connect(data)
signal player_inventory_disconnect(data)

onready var area_2d: Area2D = $Blacksmith/Area2D
onready var ui: CanvasLayer = $UI
onready var scene_tree: = get_tree()
onready var lamp_area: Area2D = $AnimatedSprite/Light2D/LampArea

export (Vector2) var eye_sight
export var entered_sound = preload("res://Sounds/Ambience/entrance.ogg")
export var exited_sound = preload("res://Sounds/Ambience/exit.ogg")
var player = null

func _ready() -> void:
	add_to_group("Merchant")
	lamp_area.add_to_group("Light_Source")
	area_2d.connect("area_entered", self, "customer_available")
	area_2d.connect("area_exited", self, "customer_exited")
	lamp_area.connect("area_entered", self, "enemy_entered")
	lamp_area.connect("area_exited", self, "enemy_exited")
	connect("tree_entered", self, "entered")
	connect("tree_exited", self, "exited")

func entered():
	Signals.play_Theme(entered_sound, self)

func exited():
	Signals.play_Theme(exited_sound, self)

func customer_available(body: Area2D):
	player = body
	emit_signal("player_inventory_connect", player.get_parent())
	Signals.change_camera(self, eye_sight, 1.0)
	Signals.player_Selected.emit_signal("focus")
	ui.visible = true

func customer_exited(body: Area2D):
	player = null
	emit_signal("player_inventory_disconnect", null)
	Signals.change_camera(Signals.player_Selected, Signals.player_Selected.eye_sight, 1.5)
	ui.visible = false
	Signals.player_Selected.emit_signal("focus")

func enemy_entered(body: Area2D) -> void:
	if body.get_parent().is_in_group("Enemies"):
		Signals.arrayEnemies.sort_custom(Signals,"sortArray")
		Signals.arrayEnemies.append(body)

func enemy_exited(body: Area2D) -> void:
	if body.get_parent().is_in_group("Enemies"):
		Signals.arrayEnemies.sort_custom(Signals,"sortArray")
		Signals.arrayEnemies.erase(body)
