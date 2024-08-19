extends "res://Actors/Player/PlayerBase.gd"

# warning-ignore:unused_signal
signal focus
signal hit

var start_pistol = preload("res://Gun_prefabs/Weapon_tres/Pistol.tres")

export (NodePath) onready var Health_Component = get_node(Health_Component) as Area2D

func _ready() -> void:
	max_health = Health
	Health_Component.connect("damage_dealt", self, "take_hit")
	if Inventory_Resource:
		add_child(Light_Source.instance())
		add_child(Gun_Positions.instance())

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	Signals.emit_signal("player_Position", global_position)
	if regeneration and !regen_stop:
		Health = lerp(Health, target_regen, delta)
		if Health == target_regen:
			regeneration = false
			target_regen = 0

func regen(value):
	if Health == max_health:
		regeneration = false
	elif Health <= max_health:
		target_regen = Health + value
		regeneration = true

func take_hit(value):
	emit_signal("hit")
	if Health >= 1:
		Health -= value
		regen_stop = true
		var timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", self,"regen_status")
		timer.connect("timeout", timer,"queue_free")
		timer.start(value / 4)

	if Health <= 0:
		Signals.emit_signal("dead")

