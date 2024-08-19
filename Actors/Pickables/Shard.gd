extends Area2D

onready var timer = $Timer

export var amount = 0

func _ready() -> void:
	add_to_group("PickUps")
# warning-ignore:return_value_discarded
	$".".connect("area_entered", self, "picked")
	timer.connect("timeout", self, "time")
	timer.wait_time = 5
	timer.autostart = true
	timer.one_shot = true
	amount = ShopItems.rng.randi_range(10, 50)

func _process(_delta: float) -> void:
	if !Signals.player_Selected:
		queue_free()

# warning-ignore:unused_argument
func picked(body: Area2D):
	ShopItems.update_currency(amount)
	queue_free()

func time():
	queue_free()
