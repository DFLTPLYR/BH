extends Node

onready var rng = RandomNumberGenerator.new()

var light_source = null

#money
var currency = 500
var value = 500
var reroll_cost = 0

var item_cost = null
var attainable = false

var item_dictionary = [
	{
		"name" : "Speed Boost",
		"texture" : preload("res://Assests/UI/Speed.png"),
		"value" : 10
	},
	{
		"name" : "Regen Boost",
		"texture" : preload("res://Assests/pickups/Health.png"),
		"value" : 10
	},
	{
		"name" : "Health Up",
		"texture" : preload("res://Assests/UI/Health_Up.png"),
		"value" : 5
	}
]

var Shop_item = [
	{
		"name" : "pistol",
		"reference" : "res://Gun_prefabs/Weapon_tres/Pistol.tres"
	},
	{
		"name" : "p90",
		"reference" : "res://Gun_prefabs/Weapon_tres/P90.tres"
	},
	{
		"name" : "Shotgun",
		"reference" : "res://Gun_prefabs/Weapon_tres/Shotgun.tres"
	}
]

func _ready() -> void:
	rng.randomize()

func _process(delta: float) -> void:
	currency = lerp(currency, value, 2.5 * delta)

func update_currency(item_value):
	value = currency + item_value

func check_price(item_value):
	if value > item_value:
		attainable = true
	else:
		attainable = false

