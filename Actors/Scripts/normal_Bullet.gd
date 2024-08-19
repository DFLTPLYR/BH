extends Area2D

export (float) var bulletSpeed = 1.0
export (float) var bulletLife = 1.4

export (int) var damage = 0

onready var timer = $Timer

func _ready() -> void:
	timer.connect("timeout", self, "lifespawn")
# warning-ignore:return_value_discarded
	$".".connect("body_entered", self, "damage")
	
	timer.wait_time = bulletLife
	timer.start()
	add_to_group("Projectiles")

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	global_position += transform.x * bulletSpeed

func lifespawn() -> void:
	queue_free()

# warning-ignore:function_conflicts_variable
func damage(body: Node) -> void:
	body.hit(damage)
	self.queue_free()
