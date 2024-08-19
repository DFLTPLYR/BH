extends Area2D

export (float) var bulletSpeed:float
export (float) var bulletLife:float
export (int) var Damage:float
export (int) var Piercing:int


onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = bulletLife
	timer.start()
	add_to_group("Projectiles")
	$Timer.connect("timeout", self, "lifetime")
	$".".connect("area_entered", self, "hit")

func _physics_process(delta: float) -> void:
	global_position += transform.x * bulletSpeed
	if Piercing == 0:
		self.queue_free()

func lifetime() -> void:
	call_deferred("queue_free")

func hit(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(Damage)
		Piercing += -1
