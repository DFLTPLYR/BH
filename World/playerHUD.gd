extends CanvasLayer

export (NodePath) onready var wave_progress = get_node(wave_progress) as TextureProgress
export (NodePath) onready var Health_bar = get_node(Health_bar) as TextureProgress
export (NodePath) onready var fuel_bar = get_node(fuel_bar) as TextureProgress
export (NodePath) onready var currency_text = get_node(currency_text) as Label
export (NodePath) onready var Rounds = get_node(Rounds) as Label
export (NodePath) onready var enemy_count = get_node(enemy_count) as Label
export (NodePath) onready var player_picture = get_node(player_picture) as TextureRect
onready var speed_stat: Label = $UserInformation/PlayerInformation/Speed/speed_stat
onready var health_stat: Label = $UserInformation/PlayerInformation/Speed/Health_stat

onready var parent = get_parent()


var wave_timer = null
var player = null
var max_fuel = null

var enemies_spawned:float

func _ready() -> void:
	self.visible = false
	player = Signals.player_Selected
	wave_timer = Signals.global_wave_timer

	Signals.connect("wave_Start", self, "visibility")
	Signals.connect("current_wave_time", self, "update_max_value")
	Signals.connect("wave_End", self, "visibility")
	Signals.connect("dead", self, "visibility")
	player.connect("focus", self, "visibility")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(wave_timer):
		currency_text.text = "%s" % round(ShopItems.currency)

		player_picture.texture = player.picture
		Health_bar.max_value = player.max_health
		Health_bar.value = player.Health
		speed_stat.text = "%s" % player.speed
		health_stat.text = "%s / %s" % [round(player.Health), player.max_health]

		wave_progress.value = wave_timer.time_left
		Rounds.text = "Wave: %s" % Signals.wave
	else:
		pass

	if is_instance_valid(ShopItems.light_source):
		fuel_bar.max_value = ShopItems.light_source.fuel_tank
		fuel_bar.value = ShopItems.light_source.fuel_left
	else:
		pass

	var e_count = get_tree().get_nodes_in_group("Enemies")
	if e_count.size() <= 0:
		enemy_count.visible = false
	else:
		enemies_spawned = lerp(enemies_spawned, e_count.size(), delta)
		enemy_count.visible = true
		enemy_count.text = "Enemy Count: %s" % round(enemies_spawned)

func update_max_value(value):
	wave_progress.max_value = value

func visibility():
	self.visible = !self.visible
