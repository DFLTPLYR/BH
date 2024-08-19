extends GridContainer

onready var player_name: Label = $PlayerInfo/PlayerName
onready var profile_pic: TextureRect = $PlayerInfo/ProfilePic
onready var health: Label = $PlayerInfo2/health
onready var black_smith: KinematicBody2D = $"../../../.."

var max_health = null

func _ready() -> void:
	black_smith.connect("player_inventory_connect", self, "get_data")

func get_data(data):
	player_name.text = "%s" % data.name
	profile_pic.texture = data.picture
	health.text = "%s" % round(data.Health)
