extends AnimatedSprite

enum STATE{
	lit,
	refilling
}

onready var light_2d: Light2D = $Light2D
onready var lamp_area: Area2D = $Light2D/LampArea
onready var shape: CollisionShape2D = $Light2D/LampArea/Shape

export var refill_rate:float
export var fuel_capacity:float
export var fuel_tank:float

var fuel_left = null
var state_timer = null

var state = STATE.lit


func _init() -> void:
	var timer = Timer.new()
	state_timer = timer
	add_child(state_timer)

func _ready() -> void:
	add_to_group("Light_Source")
	light_2d.scale = Vector2(fuel_capacity, (fuel_capacity / 2 + fuel_capacity / 4))
	ShopItems.light_source = self
	lamp_area.connect("area_entered", self, "enemy_entered")
	lamp_area.connect("area_exited", self, "enemy_exited")
	fuel_left = fuel_capacity

func _process(delta: float) -> void:
	match state:
		STATE.lit:
			light(delta)
		STATE.refilling:
			refill(delta)

func light(delta):
	if fuel_capacity >= fuel_tank / 4:
		fuel_capacity -= delta * 0.005
		light_2d.scale = Vector2(fuel_capacity, ((fuel_capacity / 2) + (fuel_capacity / 4)))
	elif fuel_capacity <= fuel_tank / 4:
		pass

func refill(delta):
	fuel_capacity = max(0, fuel_tank)
	if fuel_capacity <= fuel_tank:
		fuel_capacity += refill_rate * delta
	elif fuel_capacity == fuel_tank:
		pass

func enemy_entered(body: Area2D) -> void:
	if body.get_parent().is_in_group("Enemies"):
		Signals.arrayEnemies.sort_custom(Signals,"sortArray")
		Signals.arrayEnemies.append(body)
	if body.is_in_group("Light_Source"):
		state_timer.start(5)
		if state_timer.time_left <= 0.0:
			state_timer.stop()
			state = STATE.refilling

func enemy_exited(body: Area2D) -> void:
	if body.get_parent().is_in_group("Enemies"):
		Signals.arrayEnemies.sort_custom(Signals,"sortArray")
		Signals.arrayEnemies.erase(body)
	if body.is_in_group("Light_Source"):
		state = STATE.lit
